FROM phpfpm72-dev
LABEL Name="Revive Adserver Docker Image" Version=0.0.1

ARG REVIVE_VERSION=4.1.4
ARG DOMAIN=domain.com
ARG CRON_MAINTENANCE=""

WORKDIR /var/www/html

COPY /files/revive-adserver-4.1.4.tar.gz /tmp/revive-adserver.tar.gz

RUN true && \
    tar -xzf /tmp/revive-adserver.tar.gz -C /var/www/html/ --strip-components=1 && \
    #&& curl -L https://download.revive-adserver.com/revive-adserver-$REVIVE_VERSION.tar.gz | tar -zx -C /var/www/html/ --strip-components=1 \
    ls -lah /var/www/html && \
    find /var/www/html/var -type d -exec chmod 700 {} + && \
    find /var/www/html/var -type f -exec chmod 600 {} + && \
    #&& chmod 700 /var/www/html/var \
    #&& chown -R www-data:www-data /var/www/html/plugins \
    chmod 700 /var/www/html/plugins && \
    #&& chown -R www-data:www-data /var/www/html/www/admin/plugins \
    chmod 700 /var/www/html/www/admin/plugins && \
    chown -R www-data:www-data /var/www/html/ && \
    rm -rf /tmp/revive-adserver.tar.gz && \
    ls -lah /var/www/html && \
    true

## copy custom scripts.
#COPY /docker-start.sh /
#RUN chmod +x /docker*.sh
#
#ENTRYPOINT ["/docker-start.sh"]
#CMD ["startup"]
