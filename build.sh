#!/usr/bin/env bash

# THIS IS FOR DEVELOPMENT ONLY.

set -ex

. versions.sh

TAG_PREFIX='revive-adserver'
BUILD_TMP=tmp/build
rm -rdf $BUILD_TMP
mkdir -p $BUILD_TMP
tag=`date +%F`
for version in "${!versions[@]}"; do
    PHPVersion="${versions[$version]}"
    cp -rav versions/$version/* $BUILD_TMP/
    sed -i -e "1s|.*|FROM phpfpm-$PHPVersion|" $BUILD_TMP/Dockerfile
    time docker build $BUILD_PARAMS --tag $TAG_PREFIX-$version:$tag $BUILD_TMP | tee tmp/build-$version.log
    if [ $? -gt 0 ]; then
        echo "\nERROR: failed to build versions/$version!\n"
        exit $?
    fi
    
    time docker tag $TAG_PREFIX-$version:$tag $TAG_PREFIX-$version:latest
done
