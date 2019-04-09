#!/bin/sh
set -e


sed -i "s/\bserver_name revive-adserver\;/server_name $SERVER_NAME;/g" /etc/nginx/sites-available/revive-adserver.conf
ln -s /etc/nginx/sites-available/revive-adserver.conf /etc/nginx/sites-enabled/

# Disable backups
touch /var/www/html/var/NOBACKUPS
