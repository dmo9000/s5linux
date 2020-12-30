#!/bin/sh
set -e
NPROC=`nproc`
TOPLEVEL=`pwd`
cd src
rm -rf ./coreutils-8.32
tar -zxvf coreutils-8.32.tar.gz
cd coreutils-8.32
CFLAGS=-static LDFLAGS=-static ./configure --prefix=/ 
make -j ${NPROC}
sudo make install DESTDIR=${TOPLEVEL}/install-root
