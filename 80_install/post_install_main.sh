set -x

date
start_date=$(date)

chmod 777 start_web.sh

export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-O2 -march=native"
export CXXFLAGS="$CFLAGS"

pushd /tmp
wget https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz &
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

ccache -s
ccache -z

pushd /tmp
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O
time unzip -q ccache_cache.zip
rm -f ccache_cache.zip
popd

pushd /tmp

#wget https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz
wait

tar xf aria2-1.34.0.tar.xz
pushd aria2-1.34.0
pwd
./configure --help
if [ -e /tmp/config.cache ]; then
  ./configure --prefix=/tmp/usr CONFIG_SITE="/tmp/config.cache" --enable-static=yes --enable-shared=no
else
  ./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no
  cat config.cache
  cp config.cache /tmp/
fi

timeout -sKILL 120 make -j2
# make install
# cp -r /tmp/usr ../usr

popd
popd

cp /tmp/config.cache www/

ccache -s

pushd /tmp
zip -9r ccache_cache.zip ./ccache
popd

time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT ${WEBDAV_URL} -F "file=@/tmp/ccache_cache.zip"

cp /tmp/ccache_cache.zip www/

ls -lang www/

ccache -s

echo ${start_date}
date
