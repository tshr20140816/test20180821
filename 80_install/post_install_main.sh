#!/bin/bash

set -x

date
start_date=$(date)

git --version

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
ls -lang
time tar xf ccache_cache.tar.xz
rm -f ccache_cache.tar.xz
popd

pushd /tmp
# git clone https://github.com/meganz/MEGAcmd.git
git clone --recursive --depth=1 --shallow-submodules https://github.com/meganz/MEGAcmd.git
pushd MEGAcmd
# time git submodule update --init --recursive --depth=1
time sh autogen.sh
./configure --help
time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no
time timeout -sKILL 120 make -j2 | tee /tmp/make_results.txt
popd
popd

pushd /tmp
rm -f ccache_cache.tar.xz
time tar Jcf ccache_cache.tar.xz ./ccache
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
    -H "Content-Type: application/x-compress" \
    --data-binary @/tmp/ccache_cache.tar.xz \
    ${WEBDAV_URL}

ccache -s

wc -l /tmp/make_results.txt

echo ${start_date}
date
