#!/bin/sh
set -e


sed -i "s/\bserver_name revive-adserver\;/server_name $SERVER_NAME;/g" /etc/nginx/conf.d/default.conf

# Disable backups
touch /var/www/html/var/NOBACKUPS
