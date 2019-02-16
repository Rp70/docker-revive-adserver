FROM phpfpm72
LABEL Name=docker-revive-adserver Version=0.0.1

ARG REVIVE_VERSION=4.1.4
ARG DOMAIN=domain.com
ARG CRON_MAINTENANCE=""

WORKDIR /var/www/html

ADD files/revive-adserver-4.1.4.tar.gz /var/www/html/

RUN true \
    #&& curl -L https://download.revive-adserver.com/revive-adserver-$REVIVE_VERSION.tar.gz | tar -zx -C /var/www/html/ --strip-components=1 \
    && find /var/www/html/var -type d -exec chmod 700 {} + \
    && find /var/www/html/var -type f -exec chmod 600 {} + \
    #&& chmod 700 /var/www/html/var \
    #&& chown -R www-data:www-data /var/www/html/plugins \
    && chmod 700 /var/www/html/plugins \
    #&& chown -R www-data:www-data /var/www/html/www/admin/plugins \
    && chmod 700 /var/www/html/www/admin/plugins \
    && chown -R www-data:www-data /var/www/html/ \
    && true

#ENTRYPOINT ["bash"]
CMD ["bash"]
