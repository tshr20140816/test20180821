#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fuse-ld=gold"

pushd /tmp

time git clone --depth=1 -b release-0.1.3 https://github.com/metalink-dev/libmetalink.git
pushd libmetalink
time ./buildconf
./configure --help
time ./configure --prefix=/tmp/usr --enable-shared=no
time make -j2
make install
popd

ls -lang /tmp/usr
ls -lang /tmp/usr/lib

# curl -O https://curl.haxx.se/download/curl-7.65.3.tar.xz
# tar xf curl-7.65.3.tar.xz
# pushd curl-7.65.3
curl -O https://curl.haxx.se/download/curl-7.66.0.tar.xz
tar xf curl-7.66.0.tar.xz
pushd curl-7.66.0
./configure --help
./configure --prefix=/tmp/usr --enable-shared=no --enable-static=yes \
  --with-libssh2 --with-brotli --with-nghttp2 \
  --with-gssapi --with-libmetalink=/tmp/usr
time make -j2
make install
popd
popd

curl --version
/tmp/usr/bin/curl --version
ldd /tmp/usr/bin/curl

/tmp/usr/bin/curl --help

cp /tmp/usr/bin/curl ./www/

echo ${start_date}
date
