#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

pushd /tmp

time git clone --depth=1 -b release-0.1.3 https://github.com/metalink-dev/libmetalink.git
pushd libmetalink
./buildconf
./configure --help
./configure --prefix=/tmp/usr
time make
make install
popd

ls -lang /tmp/usr
ls -lang /tmp/usr/lib

# curl -O https://curl.haxx.se/download/curl-7.65.3.tar.xz
tar xf curl-7.65.3.tar.xz
pushd curl-7.65.3
# ls -lang
./configure --help
./configure --prefix=/tmp/usr --enable-shared=no --enable-static=yes \
  --with-libssh2 --with-brotli --with-nghttp2 \
  --with-gssapi --with-libmetalink=/tmp/usr/lib
time make -j2
make install
popd
popd

curl --version
/tmp/usr/bin/curl --version

echo ${start_date}
date
