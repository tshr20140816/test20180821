#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fuse-ld=gold"

gcc --version
g++ -fuse-ld=gold -Wl,--version
gcc -c -Q -march=native --help=target

grep -c -e processor /proc/cpuinfo
cat /proc/cpuinfo | head -n $(($(cat /proc/cpuinfo | wc -l) / $(grep -c -e processor /proc/cpuinfo)))

mkdir -p /tmp/usr/bin
mkdir -p /tmp/usr/share

pushd /tmp
wget https://www.rarlab.com/rar/unrarsrc-5.7.1.tar.gz
tar xf unrarsrc-5.7.1.tar.gz
ls -lang
cd unrar
ls -lang
cat makefile
make -f makefile
ls -lang
popd

echo ${start_date}
date
