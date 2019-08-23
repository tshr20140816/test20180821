#!/bin/bash

set -x

date
start_date=$(date)

pbzip2 --help

chmod 777 start_web.sh

cat /proc/cpuinfo

# export PATH="/tmp/usr/bin:${PATH}"

# export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
# export CXXFLAGS="$CFLAGS"
# export LDFLAGS="-fuse-ld=gold"

# mkdir -p /tmp/usr/bin
# cp ccache /tmp/usr/bin/
# chmod +x /tmp/usr/bin/ccache

export CCACHE_DIR=/tmp/ccache
# export CCACHE_COMPILERCHECK=content
export CCACHE_COMPILERCHECK=none
export CCACHE_LOGFILE=/tmp/ccache.log
export CCACHE_SLOPPINESS=pch_defines,time_macros,file_macro
export CCACHE_NOHASHDIR=true
export CCACHE_DEBUG=true
# export CCACHE_DEPEND=true

# pushd /tmp/usr/bin
# ln -s ccache gcc
# ln -s ccache g++
# ln -s ccache cc
# ln -s ccache c++
# popd

pushd /tmp
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -O ${WEBDAV_URL}ccache_cache.tar.bz2 -O ${WEBDAV_URL}MEGAcmd.tar.bz2
# tar xf ccache_cache.tar.bz2 &
tar xf MEGAcmd.tar.bz2 &
wait

pushd MEGAcmd

ccache --version
ccache -s
ccache -z
ccache -p
# dir -R ${CCACHE_DIR}

# time timeout -sKILL 90 make -j2 | tee /tmp/make_results.txt
time timeout -sKILL 30 make CC='ccache gcc' CXX='ccache g++' | tee /tmp/make_results.txt
# ls -lang /tmp/MEGAcmd/sdk/src
# cat /tmp/MEGAcmd/sdk/src/src_libmega_la-megaclient.o.ccache-input-text
cat /tmp/MEGAcmd/sdk/src/src_libmega_la-megaclient.o.ccache-log
popd
popd

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
# time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
#     -H "Content-Type: application/x-compress" \
#     --data-binary @/tmp/ccache_cache.tar.bz2 \
#     ${WEBDAV_URL}ccache_cache.tar.bz2

ccache -s

# cat /tmp/ccache.log

echo ${start_date}
date
