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
wget https://github.com/google/brotli/archive/v1.0.7.tar.gz &
wget https://github.com/apache/httpd/archive/2.4.38.tar.gz &
wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz
popd

if [ -e ccache ]; then
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
  pushd /tmp
  curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
  if [ -e ccache_cache.tar.xz ]; then
    time tar xf ccache_cache.tar.xz
    rm -f ccache_cache.tar.xz
  fi
  popd
  ccache -z
fi

pushd /tmp
tar xf cmake-3.14.0-Linux-x86_64.tar.gz
pushd cmake-3.14.0-Linux-x86_64
cp -f bin/* /tmp/usr/bin/
cp -rf share /tmp/usr
popd
popd

wait

pushd /tmp

# wget wget https://github.com/google/brotli/archive/v1.0.7.tar.gz
tar xf v1.0.7.tar.gz
pushd brotli-1.0.7
mkdir out
pushd out
../configure-cmake --help
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/tmp/usr ..
cmake --build . --config Release --target install
popd
popd

ls -lang /tmp/usr/bin
ls -lang /tmp/usr/lib

pushd /tmp
rm -f ccache_cache.tar.xz
time tar Jcf ccache_cache.tar.xz ./ccache
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
  -H "Content-Type: application/x-compress" \
  --data-binary @/tmp/ccache_cache.tar.xz \
  ${WEBDAV_URL}

echo ${start_date}
date
