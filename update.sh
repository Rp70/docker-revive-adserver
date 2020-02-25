#!/usr/bin/env bash

# THIS IS FOR DEVELOPMENT ONLY.


set -e

. versions.sh


for version in "${!versions[@]}"; do
    Dockerfile=versions/$version/Dockerfile
    PHPVersion="${versions[$version]}"

    echo "Updating $version"
    rm -rf versions/$version
    mkdir -p versions/$version
    cp -r README.md template/* versions/$version/

    sed -i \
      -e 's/{{ PHP_VERSION }}/'$PHPVersion'/g' \
      -e "s/\(ENV REVIVE_VERSION\) .*/\1 $version/g" \
      $Dockerfile
    
done
