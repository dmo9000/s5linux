#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=sysvinit-2.98
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./configure --prefix=/usr 
make  -j ${NPROC}
make install ROOT=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXsysvinit
NAME=${PKGNAME}
DESC=SysV Init
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

