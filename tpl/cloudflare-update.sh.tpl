#!/bin/bash

# Hardcoded variables
EMAIL=%%EMAIL%%
GAPIK=%%GAPIK%%
ZONE=%%ZONE%%

if [ -z "$GAPIK" ] || [ -z "$EMAIL" ] || [ -z "$ZONE" ]; then
    echo "Missing required environment variables!!" 1>&2
    exit 1
fi

#
# Functions
#

# Gets the Identifier attribute that signifies a singular DNS Record under a domain in Cloudflare.
function getIdent {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | grep "id" \
             | grep -v "zone" \
             | sed 's/ //g' \
             | sed 's/{"id":"//g' \
             | sed 's/"//g'
}
# Gets the type of DNS Record
function getType {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | grep "type" \
             | sed 's/ //g' \
             | sed 's/"type":"//g' \
             | sed 's/"//g'
}
# Gets the subdomain corresponding to an Identifier
function getSub {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | grep "name" \
             | grep -v "zone" \
             | sed 's/ //g' \
             | sed 's/"name":"//g' \
             | cut -f1 -d"."
}
# Gets the boolean value of if the subdomain is using Cloudflare's proxy service
function getProxy {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | sed 's/{//g' \
             | grep "proxied" \
             | sed 's/"proxied"://g' \
             | sed 's/"//g'
}
# Finds current IP address and sends it to a DNS A Record
function setIP {
        IP=$(curl -s4 ifconfig.co)
        curl -sX PUT "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             --data '{"type":"A","name":"'$SUB'","content":"'$IP'","proxied":'$PROXY'}' \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | grep "content\|name\|proxied\|success" \
             | grep -v "zone" \
             | sed 's/ //g'
}

#
# Script main -- Sends the current IP address to your DNS A Records, excluding anything that is not an A Record. Supports any number of subdomains.
#
getIdent | while read -r IDENT; do
        if [ $(getType) = "A" ]; then
                SUB=$(getSub)
                PROXY=$(getProxy)
                setIP
                echo "-----------------"
        fi;done
echo "*****************"
