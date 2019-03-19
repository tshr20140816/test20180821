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

if [ -e aria2c ]; then
  chmod +x aria2c
  mv aria2c /tmp/usr/bin
fi

if [ -e config.cache ]; then
  cp config.cache /tmp/
fi

if [ -e ccache ]; then
  mkdir -p /tmp/usr/bin
  cp ccache /tmp/usr/bin/
  chmod +x /tmp/usr/bin/ccache
else
pushd /tmp

wget https://www.samba.org/ftp/ccache/ccache-3.6.tar.xz

tar xf ccache-3.6.tar.xz
pushd ccache-3.6

./configure --help
./configure --prefix=/tmp/usr

make -j2
make install

ls -lang /tmp/usr
ls -lang /tmp/usr/bin
ls -lang /tmp/usr/share

popd
popd

cp /tmp/usr/bin/ccache www/
fi

export CCACHE_DIR=/tmp/ccache

pushd /tmp/usr/bin
ln -s ccache gcc
ln -s ccache g++
ln -s ccache cc
ln -s ccache c++
popd

gcc --version

ccache -s
ccache -z

pushd /tmp
# wget https://github.com/google/brotli/archive/v1.0.7.tar.gz &
if [ -e /tmp/usr/bin/aria2c ]; then
  aria2c --console-log-level=info -x2 https://github.com/google/brotli/archive/v1.0.7.tar.gz &
  aria2c --console-log-level=info -x2 https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz &
else
  wget https://github.com/google/brotli/archive/v1.0.7.tar.gz &
  wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz &
fi
wget https://github.com/nghttp2/nghttp2/releases/download/v1.37.0/nghttp2-1.37.0.tar.xz
curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
wget https://curl.haxx.se/download/curl-7.64.0.tar.xz &
wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz &
popd

pushd /tmp
# time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
if [ -e ccache_cache.tar.xz ]; then
  ls -lang ccache_cache.tar.xz
  file ccache_cache.tar.xz
  time tar xf ccache_cache.tar.xz
  rm -f ccache_cache.tar.xz
fi
popd

pushd /tmp
tar xf nghttp2-1.37.0.tar.xz
pushd nghttp2-1.37.0
./configure --help
time ./configure --prefix=/tmp/usr --enable-lib-only
time make -j2
time make install
popd
popd

ccache -s

pushd /tmp
time tar Jcf ccache_cache.tar.xz ./ccache
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
    -H "Content-Type: application/x-compress" \
    --data-binary @/tmp/ccache_cache.tar.xz \
    ${WEBDAV_URL}
rm -f /tmp/ccache_cache.tar.xz

wait

pushd /tmp

# wget https://github.com/google/brotli/archive/v1.0.5.tar.gz &

# cmake

tar xf cmake-3.14.0-Linux-x86_64.tar.gz
pushd cmake-3.14.0-Linux-x86_64
cp -f bin/* /tmp/usr/bin/
cp -rf share /tmp/usr
popd

# libssh2

# wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz
tar xf libssh2-1.8.0.tar.gz
pushd libssh2-1.8.0
./configure --help
time ./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no
time make -j2
time make install
popd
popd

wait
# cp configure-cmake /tmp/configure-cmake

pushd /tmp

# brotli

# wget https://github.com/google/brotli/archive/v1.0.7.tar.gz
if [ -e brotli-1.0.7.tar.gz ]; then
  mv brotli-1.0.7.tar.gz v1.0.7.tar.gz
fi
tar xf v1.0.7.tar.gz
pushd brotli-1.0.7
# cp -f /tmp/configure-cmake ./
# chmod +x configure-cmake
mkdir out
pushd out
../configure-cmake --help
# time ../configure-cmake --prefix=/tmp/usr
# ls -lang
# time make -j2
# time make install
ls -lang
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/tmp/usr ..
ls -lang
cmake --build . --config Release --target install
popd
popd

ls -lang /tmp/usr/lib
ldd /tmp/usr/bin/brotli

#wget https://curl.haxx.se/download/curl-7.64.0.tar.xz

tar xf curl-7.64.0.tar.xz
pushd curl-7.64.0
pwd
export LD_LIBRARY_PATH=/tmp/usr/lib:${LD_LIBRARY_PATH}
./configure --help
# export LDFLAGS="-fuse-ld=gold -L/tmp/usr/lib -Wl,-rpath /tmp/usr/lib"
if [ -e /tmp/config.cache ]; then
  time ./configure --prefix=/tmp/usr CONFIG_SITE="/tmp/config.cache" --enable-static=yes --enable-shared=no \
    --with-libssh2=/tmp/usr --with-brotli=/tmp/usr --with-nghttp2=/tmp/usr
  # time ./configure --prefix=/tmp/usr CONFIG_SITE="/tmp/config.cache" --enable-static=yes --enable-shared=no \
  #   --with-libssh2=/tmp/usr --with-nghttp2=/tmp/usr
else
  time ./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no \
    --with-libssh2=/tmp/usr --with-brotli=/tmp/usr --with-nghttp2=/tmp/usr
  # time ./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no \
  #   --with-libssh2=/tmp/usr --with-nghttp2=/tmp/usr
  cat config.cache
  cp config.cache /tmp/
fi

date
check_point_010_date=$(date)

time timeout -sKILL 40 make -j$(grep -c -e processor /proc/cpuinfo)
if [ $? != 0 ]; then
  echo 'time out'
  result='NG'
else
  result='OK'
  time make install
fi

ls -lang /tmp/usr
ls -lang /tmp/usr/bin

# cp -r /tmp/usr ../usr

popd
popd

ldd /tmp/usr/bin/curl

cp /tmp/usr/bin/curl www/
cp /tmp/config.cache www/

pushd /tmp
ls -lang
rm -f ccache_cache.tar.xz
ls -lang
time tar Jcf ccache_cache.tar.xz ./ccache
ls -lang
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
    -H "Content-Type: application/x-compress" \
    --data-binary @/tmp/ccache_cache.tar.xz \
    ${WEBDAV_URL}
ls -lang www/

ccache -s

/tmp/usr/bin/curl --verbose ${URL} 1> /dev/null

echo ${start_date}
echo ${check_point_010_date}
date
