set -x

date
start_date=$(date)

chmod 777 start_web.sh

export CFLAGS="-O2 -march=native"
export CXXFLAGS="$CFLAGS"

if [ -e ccache ]; then
  echo 'HELLO'
fi
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

pushd /tmp

wget https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz

tar xf aria2-1.34.0.tar.xz
pushd aria2-1.34.0
pwd
./configure --help
./configure --prefix=/tmp/usr --config-cache --enable-static=yes --enable-shared=no

cat config.cache
cp config.cache /tmp/
# make -j8
# make install
# cp -r /tmp/usr ../usr

popd
popd

cp /tmp/config.cache www/

echo ${start_date}
date
