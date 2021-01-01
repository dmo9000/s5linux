#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=binutils-2.35
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
mkdir -p build/binutils
cd build/binutils

# configure/build/install

../../${PKGNAME}/configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXbinutils
NAME=${PKGNAME}
DESC=binutils
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

