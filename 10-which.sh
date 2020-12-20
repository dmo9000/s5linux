#!/bin/sh
NPROC=`nproc`
TOPLEVEL=`pwd`
mkdir -p install-root/bin
cd src
rm -rf ./which-2.21
tar -zxvf which-2.21.tar.gz
cd which-2.21
CFLAGS=-static LDFLAGS=-static ./configure --prefix=/ --enable-static-link 
make -j ${NPROC}
sudo make install DESTDIR=${TOPLEVEL}/install-root
