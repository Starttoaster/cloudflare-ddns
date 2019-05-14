#!/bin/bash

read -p "Enter your account email: " -r EMAIL
read -p "Enter your Global API Key: " -r GAPIK
read -p "Enter your Zone ID: " -r ZONE

mkdir ~/cloudflare-update
sed -e "s#%%GAPIK%%#${GAPIK}#g" -e "s#%%ZONE%%#${ZONE}#g" -e "s#%%EMAIL%%#${EMAIL}#g" ./tpl/cloudflare-update.sh.tpl >~/cloudflare-update/cloudflare-update.sh
chmod +x ~/cloudflare-update/cloudflare-update.sh

echo "Your script has been setup in your user's home directory under cloudflare-update/cloudflare-update.sh"
