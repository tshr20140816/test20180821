set -x

date
start_date=$(date)

chmod 777 start_web.sh

export CFLAGS="-O2 -march=native"
export CXXFLAGS="$CFLAGS"

cd /tmp

wget https://www.samba.org/ftp/ccache/ccache-3.6.tar.xz

tar xf ccache-3.6.tar.xz
cd ccache-3.6

./configure --help
./configure --prefix=/tmp/usr

make -j8
make install

ls -lang /tmp/usr
ls -lang /tmp/usr/bin

cd ..

wget https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz

tar xf aria2-1.34.0.tar.xz
cd aria2-1.34.0
pwd
./configure --help
./configure --prefix=/tmp/usr

cat config.cache

# make -j8
# make install
# cp -r /tmp/usr ../usr

echo ${start_date}
date
