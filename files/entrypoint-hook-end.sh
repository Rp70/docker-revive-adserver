#!/bin/sh
set -e
#set -o pipefail

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
    echo "sudo -u www-data php -d memory_limit=500M /var/www/html/maintenance/maintenance.php $SERVER_NAME" >> /etc/cron.hourly/revive-adserver;
    chmod +x /etc/cron.hourly/revive-adserver;
fi

# Setting permissions or installation/upgrade process will report permissions error
find /var/www/html/var -type d -exec chmod 700 {} + | true && \
find /var/www/html/var -type f -exec chmod 600 {} + | true && \
chmod 700 /var/www/html/plugins | true && \
chmod 700 /var/www/html/www/admin/plugins | true && \
chown -R www-data:www-data /var/www/html | true

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


# Re-create UPGRADE in case /var/www/html/var re-mount
touch /var/www/html/var/UPGRADE
