#!/bin/bash

set -x

date
start_date=$(date)

export PATH="/tmp/usr/bin:${PATH}"

# export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
# export CXXFLAGS="$CFLAGS"
# export LDFLAGS="-fuse-ld=gold"

mkdir -p /tmp/usr/bin
cp ccache /tmp/usr/bin/
chmod +x /tmp/usr/bin/ccache

export CCACHE_DIR=/tmp/ccache

pushd /tmp/usr/bin
ln -s ccache gcc
ln -s ccache g++
ln -s ccache cc
ln -s ccache c++
popd

ccache -s
ccache -z

pushd /tmp
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
time unzip -q ccache_cache.zip
rm -f ccache_cache.zip
popd

pushd /tmp
git clone https://github.com/meganz/MEGAcmd.git
pushd MEGAcmd
time git submodule update --init --recursive
time sh autogen.sh
./configure --help
time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no
time timeout -sKILL 180 make -j2
popd
popd

pushd /tmp
zip -9qr ccache_cache.zip ./ccache
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT ${WEBDAV_URL} -F "file=@/tmp/ccache_cache.zip"

ccache -s

echo ${start_date}
date
