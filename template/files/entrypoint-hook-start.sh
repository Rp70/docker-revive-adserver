#!/usr/bin/env bash
set -e

if [ "$SERVER_NAME" = '' ]; then
    echo '$SERVER_NAME is not defined!';
    exit 1;
fi

# Defaults if not specified from container's config.
CRON_ENABLE=${CRON_ENABLE:='1'}
CRON_COMMANDS=${CRON_COMMANDS:=''}
MEMCACHED_ENABLE=${MEMCACHED_ENABLE:='1'}
NGINX_ENABLE=${NGINX_ENABLE:='1'}
NGINX_PROCESSES=${NGINX_PROCESSES:='2'}
NGINX_REALIP_FROM=${NGINX_REALIP_FROM:=''}
NGINX_REALIP_HEADER=${NGINX_REALIP_HEADER:='X-Forwarded-For'}

# Defaults for Revive only
REVIVE_NOBACKUPS=${REVIVE_NOBACKUPS:=''}
REVIVE_INSTALLED=${REVIVE_INSTALLED:=''}
REVIVE_MAINTENANCE=${REVIVE_MAINTENANCE:=''}
