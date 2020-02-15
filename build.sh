#!/usr/bin/env bash
set -e

. versions.sh

for version in "${!versions[@]}"; do
    tag=`date +%F`
    #time docker pull php:$version-fpm
    time docker build --pull --tag revive-adserver-$version:$tag versions/$version | tee tmp/revive-adserver-$version.log
    time docker tag revive-adserver-$version:$tag revive-adserver-$version:latest
done
