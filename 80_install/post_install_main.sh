#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

pushd /tmp/

ymd=$(date +'%Y%m%d')
mkdir ${ymd}
pushd ${ymd}
curl -L -O https://github.com/google/brotli/archive/v1.0.7.tar.gz
ls -lang
tar xf v1.0.7.tar.gz --strip-components 1
rm v1.0.7.tar.gz
ls -lang
./configure --help
./configure --prefix=/tmp/usr
time make -j2
popd
popd

echo ${start_date}
date
