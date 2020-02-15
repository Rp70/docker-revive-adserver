FROM rp70/php-fpm:7.4
LABEL Name="Revive Adserver Docker Image" Version=0.0.2
LABEL Maintainer="https://github.com/Rp70"

ENV REVIVE_VERSION 4.2.1

WORKDIR /var/www/html

COPY files/ /

RUN set -ex && \
    chmod +x /entrypoint*.sh && \
    #tar -xzf /tmp/revive-adserver-$REVIVE_VERSION.tar.gz -C /var/www/html/ --strip-components=1 && \
    curl -L https://download.revive-adserver.com/revive-adserver-$REVIVE_VERSION.tar.gz | tar -xz -C /var/www/html/ --strip-components=1 && \
    chown -R www-data:www-data /var/www/html && \
    rm -rf /tmp/revive-adserver-*.tar.gz && \
    ls -lah /var/www/html


#ENTRYPOINT ["/entrypoint.sh"]
#CMD ["startup"]
