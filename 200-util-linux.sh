#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=util-linux-2.36
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

#CFLAGS=-static LDFLAGS=-static ./configure --prefix=/ --disable-wall --disable-mount --enable-static-programs
#make LDFLAGS=--static -j ${NPROC}
./configure --prefix=/ --disable-wall --disable-mount 
make  -j ${NPROC}
sudo make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXutillinux
NAME=${PKGNAME}
DESC=Linux utilities
VENDOR=HeadRat Linux
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

