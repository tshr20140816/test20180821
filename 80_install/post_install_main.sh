#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

pbzip2 --help
megatools --version

pushd /tmp
curl -O https://curl.haxx.se/download/curl-7.65.3.tar.xz
tar xf curl-7.65.3.tar.xz
pushd curl-7.65.3
ls -lang
popd
popd

echo ${start_date}
date
