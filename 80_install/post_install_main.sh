#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

cat << '__HEREDOC__' >jobs.txt
curl -v --compressed -O https://oscdl.ipa.go.jp/IPAexfont/ipaexg00401.zip
curl -v --compressed -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcs.phar
curl -v --compressed -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcbf.phar
__HEREDOC__

# time cat jobs.txt | parallel -j2

curl -v -o migu-1m-20150712.zip https://ja.osdn.net/frs/redir.php?m=iij&f=mix-mplus-ipa%2F63545%2Fmigu-1m-20150712.zip

ls -lang
unzip migu-1m-20150712.zip
ls -lang

echo ${start_date}
date
