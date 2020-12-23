#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup
set -e
PKGNAME=gcc-10.2.0
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
mkdir -p build/${PKGNAME}
cd build/${PKGNAME}

# configure/build/install

../../${PKGNAME}/configure --prefix=/usr  --enable-languages=c --disable-multilib --disable-shared
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXgcc
NAME=${PKGNAME}
DESC=gcc and g++
VENDOR=HeadRat Linux
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

