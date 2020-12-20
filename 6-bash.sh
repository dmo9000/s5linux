#!/bin/sh
NPROC=`nproc`
TOPLEVEL=`pwd`
mkdir -p install-root/bin
cd src
rm -rf ./bash-5.1
tar -zxvf bash-5.1.tar.gz
cd bash-5.1
CFLAGS=-static LDFLAGS=-static ./configure --prefix=/ --enable-static-link 
make -j ${NPROC}
sudo make install DESTDIR=${TOPLEVEL}/install-root
