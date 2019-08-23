#!/bin/bash

set -x

cat /proc/cpuinfo

# export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
# export CXXFLAGS="$CFLAGS"
# export LDFLAGS="-fuse-ld=gold"

pushd /tmp

time git clone --recursive --depth=1 --shallow-submodules https://github.com/meganz/MEGAcmd.git

pushd MEGAcmd

time sh autogen.sh
time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no

time make -j8
popd
popd
