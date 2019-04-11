#!/bin/sh
set -e

# Setting some customs
sed -i "s/\bserver_name revive-adserver\;/server_name $SERVER_NAME;/g" /etc/nginx/sites-available/revive-adserver.conf
ln -s /etc/nginx/sites-available/revive-adserver.conf /etc/nginx/sites-enabled/

# Disable backups
touch /var/www/html/var/NOBACKUPS
#touch /var/www/html/var/INSTALLED


# Setting permissions
find /var/www/html/var -type d -exec chmod 700 {} + && \
find /var/www/html/var -type f -exec chmod 600 {} + && \
chmod 700 /var/www/html/plugins && \
chmod 700 /var/www/html/www/admin/plugins && \
chown -R www-data:www-data /var/www/html
