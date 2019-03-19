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
wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz

tar xf cmake-3.14.0-Linux-x86_64.tar.gz
pushd cmake-3.14.0-Linux-x86_64
cp -f bin/* /tmp/usr/bin/
cp -rf share /tmp/usr
popd
popd

pushd /tmp

wget wget https://github.com/google/brotli/archive/v1.0.7.tar.gz
tar xf v1.0.7.tar.gz
pushd brotli-1.0.7
mkdir out
pushd out
../configure-cmake --help
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/tmp/usr ..
cmake --build . --config Release --target install
popd
popd

echo ${start_date}
date
