#!/bin/bash

set -x

date
start_date=$(date)

pbzip2 --help

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
# export CCACHE_COMPILERCHECK=content
# export CCACHE_COMPILERCHECK=none

pushd /tmp/usr/bin
ln -s ccache gcc
ln -s ccache g++
ln -s ccache cc
ln -s ccache c++
popd

pushd /tmp
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -O ${WEBDAV_URL}ccache_cache.tar.bz2 -O ${WEBDAV_URL}MEGAcmd.tar.bz2
tar xf ccache_cache.tar.bz2 &
ls -lang

# time git clone --recursive --depth=1 --shallow-submodules https://github.com/meganz/MEGAcmd.git
# time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL}MEGAcmd.tar.bz2 -O
tar xf MEGAcmd.tar.bz2
pushd MEGAcmd
time sh autogen.sh
./configure --help
if [ -e /tmp/config.cache ]; then
  time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no CONFIG_SITE="/tmp/config.cache"
else
  time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no --config-cache
  cp config.cache /tmp/
fi

wait

ccache --version
ccache -s
ccache -z
ccache -p
# dir -R ${CCACHE_DIR}

# time timeout -sKILL 90 make -j2 | tee /tmp/make_results.txt
time timeout -sKILL 120 make | tee /tmp/make_results.txt
popd
popd

cp /tmp/config.cache www/

ccache -s

wc -l /tmp/make_results.txt

pushd /tmp
rm -f ccache_cache.tar.bz2
# tar -I pbzip2 cf ccache_cache.tar.bz2 ./ccache
time tar cf ccache_cache.tar ./ccache
time pbzip2 -p2 --fast ccache_cache.tar
ls -lang ccache_cache.tar.bz2
if [ ! -e /tmp/ccache_cache.tar.bz2 ]; then
  time tar jcf ccache_cache.tar.bz2 ./ccache
  ls -lang ccache_cache.tar.bz2
fi
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}ccache_cache.tar.bz2
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
    -H "Content-Type: application/x-compress" \
    --data-binary @/tmp/ccache_cache.tar.bz2 \
    ${WEBDAV_URL}ccache_cache.tar.bz2

ccache -s

echo ${start_date}
date
