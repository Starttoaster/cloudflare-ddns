#!/bin/bash

read -p "Enter your account email: " -r EMAIL
read -p "Enter your Global API Key: " -r GAPIK
read -p "Enter your Zone ID: " -r ZONE

echo "This script is now set up as a personalized Cloudflare A Record updater for this domain. Run this script to update your A Records (or schedule this to run as a crontab task)"
sed -e "s#%%GAPIK%%#${GAPIK}#g" -e "s#%%ZONE%%#${ZONE}#g" -e "s#%%EMAIL%%#${EMAIL}#g" ./tpl/cloudflare-update.sh.tpl >cloudflare.sh && exit
