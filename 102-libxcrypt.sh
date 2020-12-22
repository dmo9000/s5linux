#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#
set -e

# setup

PKGNAME=libxcrypt-4.4.17
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./autogen.sh
./configure --prefix=/ 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXlibxcrypt
NAME=${PKGNAME}
DESC=libxcrypt
VENDOR=HeadRat Linux
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

