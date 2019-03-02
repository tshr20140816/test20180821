set -x

date
start_date=$(date)

chmod 777 start_web.sh

wget https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz

tar xf aria2-1.34.0.tar.xz
cd aria2-1.34.0
pwd
./configure --prefix=/tmp/usr
make -j8
make install
cp -r /tmp/usr ../usr

echo ${start_date}
date
