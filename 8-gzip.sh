#!/bin/sh
set -e
NPROC=`nproc`
TOPLEVEL=`pwd`
cd src
rm -rf ./gzip-1.10
tar -zxvf gzip-1.10.tar.gz
cd gzip-1.10
CFLAGS=-static LDFLAGS=-static ./configure --prefix=/
make -j ${NPROC}
sudo make install DESTDIR=${TOPLEVEL}/install-root
