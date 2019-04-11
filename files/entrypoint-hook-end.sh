#!/bin/sh
set -e

# Setting some customs
sed -i "s/\bserver_name revive-adserver\;/server_name $SERVER_NAME;/g" /etc/nginx/sites-available/revive-adserver.conf
ln -s /etc/nginx/sites-available/revive-adserver.conf /etc/nginx/sites-enabled/

# Disable backups if required
if [ "$REVIVE_NOBACKUPS" = '1' ]; then
    touch /var/www/html/var/NOBACKUPS
fi

# Setting maintenance script run by crond
if [ "$REVIVE_MAINTENANCE" = 'cron' ]; then
    echo "#!/bin/sh" > /etc/cron.hourly/revive-adserver;
    echo "sudo -u www-data php /var/www/html/maintenance/maintenance.php $SERVER_NAME" >> /etc/cron.hourly/revive-adserver;
    chmod +x /etc/cron.hourly/revive-adserver;
fi

# Setting permissions
find /var/www/html/var -type d -exec chmod 700 {} + && \
find /var/www/html/var -type f -exec chmod 600 {} + && \
chmod 700 /var/www/html/plugins && \
chmod 700 /var/www/html/www/admin/plugins && \
chown -R www-data:www-data /var/www/html

# Clean up current cache if any
rm -rdf /var/www/html/var/templates_compiled/** /var/www/html/var/cache/**;

if [ "$REVIVE_SECURE" = '1' ]; then
    if [ -e /var/www/html/var/INSTALLED ]; then
        rm -rf /var/www/html/www/admin/install.php \
                /var/www/html/www/admin/install-plugin.php \
                /var/www/html/www/admin/install-runtask.php;
        chmod -c 0444 /var/www/html/var/$SERVER_NAME.conf.php;
    fi
fi
