#!/usr/bin/env bash
set -e
#set -o pipefail


if [ "$NGINX_ENABLE" = '0' ]; then
	rm -f /etc/supervisor/conf.d/nginx.conf
else
	SUPERVISOR_ENABLE=$((SUPERVISOR_ENABLE+1))
	ENVIRONMENT_REPLACE="$ENVIRONMENT_REPLACE /etc/nginx"
	
	#rm -rf /etc/nginx/sites-available/default
	#sed -i 's/^user/daemon off;\nuser/g' /etc/nginx/nginx.conf
	#sed -i 's/^user www-data;/user coin;/g' /etc/nginx/nginx.conf
	sed -i "s/^worker_processes auto;/worker_processes $NGINX_PROCESSES;/g" /etc/nginx/nginx.conf
	#sed -i 's/\baccess_log[^;]*;/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf
	#sed -i 's/\berror_log[^;]*;/error_log \/dev\/stdout;/g' /etc/nginx/nginx.conf

	rm -rf /etc/nginx/modules-enabled/*.conf
	
	### realip_module ###
	# Cloudflare IPv4: https://www.cloudflare.com/ips-v4
	# Cloudflare IPv6: https://www.cloudflare.com/ips-v6
	CONFFILE=/etc/nginx/conf.d/realip.conf
	IPADDRS=""
	for ipaddr in $NGINX_REALIP_FROM; do
		if [ "$ipaddr" = "cloudflare" ]; then
			IPADDRS="$IPADDRS `curl -L -f --connect-timeout 30 https://www.cloudflare.com/ips-v4 2> /dev/null`"
			if [ $? -gt 0 ]; then
				IPADDRS="$IPADDRS `cat /tmp/cloudflare-ips-v4 2> /dev/null`"
			fi
			sleep 1

			IPADDRS="$IPADDRS `curl -L -f --connect-timeout 30 https://www.cloudflare.com/ips-v6 2> /dev/null`"
			if [ $? -gt 0 ]; then
				IPADDRS="$IPADDRS `cat /tmp/cloudflare-ips-v6 2> /dev/null`"
			fi

			NGINX_REALIP_HEADER='CF-Connecting-IP'
		else
			# Try to get IP if it's a hostname
			for ipaddr2 in `getent hosts $ipaddr | awk '{print $1}'`; do
				IPADDRS="$IPADDRS $ipaddr2"
			done
		fi
	done

	if [ "$IPADDRS" != '' ]; then
		echo "### This file is auto-generated. ###" > $CONFFILE
		echo "### Your changes will be overwriten. ###" >> $CONFFILE
		echo >> $CONFFILE
		for ipaddr in $IPADDRS; do
			echo "set_real_ip_from $ipaddr;" >> $CONFFILE
		done
		echo "real_ip_header $NGINX_REALIP_HEADER;" >> $CONFFILE
	fi
	### / realip_module ###
fi


# Setting some customs
sed -i "s/\bserver_name revive-adserver\;/server_name $SERVER_NAME;/g" /etc/nginx/sites-available/revive-adserver.conf
ln -sf /etc/nginx/sites-available/revive-adserver.conf /etc/nginx/sites-enabled/revive-adserver.conf


# Setting permissions or installation/upgrade process will report permissions error
#find /var/www/html/var -type d -exec chmod 700 {} + | true && \
#find /var/www/html/var -type f -exec chmod 600 {} + | true && \
#chmod 700 /var/www/html/plugins | true && \
#chmod 700 /var/www/html/www/admin/plugins | true && \
#chmod -R a+w /var/www/html/var | true && \
#chown -R www-data:www-data /var/www/html | true

# Clean up current cache if any in case of mounting from host.
rm -rdf /var/www/html/var/templates_compiled/** /var/www/html/var/cache/**;

if [ "$REVIVE_INSTALLED" = '1' ]; then
    if [ -e /var/www/html/var/INSTALLED ]; then
        rm -rf /var/www/html/www/admin/install.php \
                /var/www/html/www/admin/install-plugin.php \
                /var/www/html/www/admin/install-runtask.php;
        chmod -c 0444 /var/www/html/var/$SERVER_NAME.conf.php | true;
    fi

    # Setting maintenance script run by crond
    if [ "$REVIVE_MAINTENANCE" = 'cron' ]; then
        echo "#!/bin/sh" > /etc/cron.hourly/revive-adserver;
        echo "gosu www-data php -d memory_limit=500M /var/www/html/maintenance/maintenance.php $SERVER_NAME" >> /etc/cron.hourly/revive-adserver;
        chmod +x /etc/cron.hourly/revive-adserver;
    fi
else
    # Re-create UPGRADE in case /var/www/html/var re-mounted.
    touch /var/www/html/var/UPGRADE
fi

# Disable backups if required
if [ "$REVIVE_NOBACKUPS" = '1' ]; then
    touch /var/www/html/var/NOBACKUPS
fi

