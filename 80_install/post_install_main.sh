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

pushd /tmp
# wget https://curl.haxx.se/download/curl-7.64.0.tar.xz &
wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz &
wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz &
if [ -e /tmp/usr/bin/aria2c ]; then
  # aria2c -s3 -j3 -x3 -k1M https://github.com/google/brotli/archive/v1.0.7.tar.gz &
  echo 'dummy'
else
  wget https://github.com/google/brotli/archive/v1.0.7.tar.gz &
fi
curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O &
popd

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
# time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
time unzip -q ccache_cache.zip
rm -f ccache_cache.zip
popd

wait

pushd /tmp

# cmake

tar xf cmake-3.14.0-Linux-x86_64.tar.gz
pushd cmake-3.14.0-Linux-x86_64
ls -lang bin
ls -lang share
cp -rf bin/ /tmp/usr/bin/
cp -rf share /tmp/usr/share
popd
ls -lang /tmp/usr/bin
exit

# wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz
tar xf libssh2-1.8.0.tar.gz
pushd libssh2-1.8.0
./configure --help
time ./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no
time make -j2
time make install
popd

# wget https://github.com/google/brotli/archive/v1.0.7.tar.gz
tar xf v1.0.7.tar.gz
pushd brotli-1.0.7
mkdir out
pushd out
time ../configure-cmake --prefix=/tmp/usr
time make -j2
time make install
popd
popd

ls -lang /tmp/usr

exit
#wget https://curl.haxx.se/download/curl-7.64.0.tar.xz
wait

tar xf curl-7.64.0.tar.xz
pushd curl-7.64.0
pwd
./configure --help
if [ -e /tmp/config.cache ]; then
  time ./configure --prefix=/tmp/usr CONFIG_SITE="/tmp/config.cache" --enable-static=yes --enable-shared=no
else
  time ./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no --with-libssh2=/tmp/usr
  cat config.cache
  cp config.cache /tmp/
fi

time timeout -sKILL 180 make -j$(grep -c -e processor /proc/cpuinfo)
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

cp /tmp/usr/bin/curl www/
cp /tmp/config.cache www/

pushd /tmp
zip -9qr ccache_cache.zip ./ccache
popd
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT ${WEBDAV_URL} -F "file=@/tmp/ccache_cache.zip"

ls -lang www/

ccache -s

echo ${start_date}
date
