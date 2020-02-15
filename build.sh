#!/usr/bin/env bash
set -e

. versions.sh

for version in "${!versions[@]}"; do
    tag=`date +%F`
    #time docker pull php:$version-fpm
    time docker build --tag revive-adserver-$version:$tag versions/$version
    time docker tag revive-adserver-$version:$tag revive-adserver-$version:latest
done
