#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fuse-ld=gold"

pushd /tmp

time git clone -b v3.7.3 --depth=1 https://github.com/ccache/ccache.git

pushd ccache
time sh autogen.sh
./configure --help
time ./configure --prefix=/tmp/usr
time make -j2
ls -lang
popd
popd

cp /tmp/ccache/ccache www/

echo ${start_date}
date
