#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

cat /proc/cpuinfo

export PATH="/tmp/usr/bin:${PATH}"

# export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
# export CXXFLAGS="$CFLAGS"
# export LDFLAGS="-fuse-ld=gold"

mkdir -p /tmp/usr/bin
cp ccache /tmp/usr/bin/
chmod +x /tmp/usr/bin/ccache

if [ -e config.cache ]; then
  cp config.cache /tmp/
fi

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
# time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O &
# ls -lang
# time tar xf ccache_cache.tar.bz2
# rm -f ccache_cache.tar.bz2
popd

pushd /tmp
# git clone https://github.com/meganz/MEGAcmd.git
time git clone --recursive --depth=1 --shallow-submodules https://github.com/meganz/MEGAcmd.git
pushd MEGAcmd
# time git submodule update --init --recursive --depth=1
time sh autogen.sh
./configure --help
if [ -e /tmp/config.cache ]; then
  time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no CONFIG_SITE="/tmp/config.cache"
else
  time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no --config-cache
  cp config.cache /tmp/
fi

pushd /tmp
time tar xf ccache_cache.tar.bz2
rm -f ccache_cache.tar.bz2
popd

# time timeout -sKILL 90 make -j2 | tee /tmp/make_results.txt
time timeout -sKILL 10 make | tee /tmp/make_results.txt
popd
popd

cp /tmp/config.cache www/

ccache -s

wc -l /tmp/make_results.txt

pushd /tmp
rm -f ccache_cache.tar.bz2
time tar jcf ccache_cache.tar.bz2 ./ccache
ls -lang ccache_cache.tar.bz2
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
    -H "Content-Type: application/x-compress" \
    --data-binary @/tmp/ccache_cache.tar.bz2 \
    ${WEBDAV_URL}

ccache -s

echo ${start_date}
date
