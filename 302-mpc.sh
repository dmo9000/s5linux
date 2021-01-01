#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=mpc-1.2.1
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
PKG=S5LXmpc
NAME=${PKGNAME}
DESC=mpc
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

