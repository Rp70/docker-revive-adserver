#!/usr/bin/env bash

# THIS IS FOR DEVELOPMENT ONLY.


set -ex

. versions.sh

TMPBUILD=tmp/build
tag=`date +%F`
rm -rdf $TMPBUILD
mkdir -p $TMPBUILD
for version in "${!versions[@]}"; do
    PHPVersion="${versions[$version]}"
    cp -rav versions/$version/* $TMPBUILD/
    sed -i -e "1s|.*|FROM phpfpm-$PHPVersion|" $TMPBUILD/Dockerfile
    time docker build --tag revive-adserver-$version:$tag $TMPBUILD | tee tmp/build-$version.log
    time docker tag revive-adserver-$version:$tag revive-adserver-$version:latest
done
