# cloudflare-ddns
Script to set up Cloudflare dynamic DNS. Dynamic DNS is a service that ensures that your domain's A Records are always pointing at the correct IP address. Should your webserver's IP address
ever change, this script (while ran on the same machine as the webserver) ensures that your records always match the server's IP address. This is most useful if set up in crontab to run 
automatically in a time interval.

### Pre-requisite Knowledge

  1. This seems obvious but you need a domain through Cloudflare. You also need to set up 1 or more A Records in their DNS page. Note: This script does not add new A Records, it only keeps current ones updated with your current IP address. 

  2. Account Email -- This is just the email address your Cloudflare account is under.

  3. Global API Key -- This is found in the Cloudflare website under "My Profile > API Keys > Global API Key"

  4. Zone ID -- This ID is a random string of letters and numbers specific to your domain name. Found in the Cloudflare website on your domain's "Overview" page written as "Zone ID" 

### Setup

  1. Clone the repo: `git clone https://github.com/Starttoaster/cloudflare-ddns.git`

  2. Run the script: `cloudflare-ddns/setup.sh`

  3. Change directory: `~/cloudflare-update`

The script will create your personalized Cloudflare DNS A Record updating script in your home directory at `~/cloudflare-update/cloudflare-update.sh`
