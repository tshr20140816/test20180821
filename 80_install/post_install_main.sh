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

pushd /tmp
wget https://curl.haxx.se/download/curl-7.64.0.tar.xz &
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

make -j8
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
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
time unzip -q ccache_cache.zip
rm -f ccache_cache.zip
popd

pushd /tmp

#wget https://curl.haxx.se/download/curl-7.64.0.tar.xz
wait

tar xf curl-7.64.0.tar.xz
pushd curl-7.64.0
pwd
./configure --help
if [ -e /tmp/config.cache ]; then
  time ./configure --prefix=/tmp/usr CONFIG_SITE="/tmp/config.cache" --enable-static=yes --enable-shared=no
else
  time ./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no
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
