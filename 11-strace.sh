#!/bin/sh
NPROC=`nproc`
TOPLEVEL=`pwd`
mkdir -p install-root/bin
cd src
rm -rf ./strace-5.10
gunzip strace-5.10.tar.gz
tar -xvf strace-5.10.tar
cd strace-5.10
CFLAGS=-static LDFLAGS="-static -pthread" ./configure --prefix=/ --enable-static-link 
make -j ${NPROC}
sudo make install DESTDIR=${TOPLEVEL}/install-root
