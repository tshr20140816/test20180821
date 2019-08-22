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
# ls -lang
./configure --help
./configure --prefix=/tmp/usr
time make -j2
make install
popd
popd

curl --version
/tmp/usr/bin/curl --version

echo ${start_date}
date
