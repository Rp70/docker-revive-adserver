FROM rp70/php-fpm:7.4
LABEL Name="Revive Adserver Docker Image" Version=0.1.0
LABEL Maintainer="https://github.com/Rp70"

ENV REVIVE_VERSION 4.2.1

COPY ./files/ /

WORKDIR /var/www/html

RUN set -ex && \
    chmod +x /entrypoint*.sh

RUN set -ex && \
	apt-get update -y && \
    apt-install nginx && \
    rm -f /var/www/html/index.nginx-debian.html && \
    apt-clean

RUN set -ex && \
    curl -f --output /tmp/cloudflare-ips-v4 --connect-timeout 30 https://www.cloudflare.com/ips-v4 2> /dev/null && \
	sleep 3 && \
	curl -f --output /tmp/cloudflare-ips-v6 --connect-timeout 30 https://www.cloudflare.com/ips-v6 2> /dev/null && \
	ls -lah /tmp/cloudflare*

RUN set -ex && \
    curl -L https://download.revive-adserver.com/revive-adserver-$REVIVE_VERSION.tar.gz | tar -xz -C /var/www/html/ --strip-components=1 && \
    chown -R www-data:www-data /var/www/html && \
    rm -rf /tmp/revive-adserver-*.tar.gz && \
    ls -lah /var/www/html

#ENTRYPOINT ["/entrypoint.sh"]
#CMD ["startup"]
