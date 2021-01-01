#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=e2fsprogs-1.45.6
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./configure --prefix=/ 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXe2fsprogs
NAME=${PKGNAME}
DESC=Linux e2fsprogs
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

