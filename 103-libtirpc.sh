#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

set -e

PKGNAME=libtirpc-1.2.6
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./configure --prefix=/ --disable-gssapi 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXlibtirpc
NAME=${PKGNAME}
DESC=libtirpc
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

