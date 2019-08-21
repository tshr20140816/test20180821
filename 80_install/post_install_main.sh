#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fuse-ld=gold"

cd /tmp

time git clone -b v3.7.3 --depth=1 https://github.com/ccache/ccache.git

cd ccache
time sh autogen.sh
./configure --help
time ./configure --prefix=/tmp/usr
time make -j2
time make install

ls -lang /tmp/usr
ls -lang /tmp/usr/bin

echo ${start_date}
date
