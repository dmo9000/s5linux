#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=bash-5.1
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
make install DESTDIR=${PKGDIR}
cd ${PKGDIR}/bin && ln -sf ../usr/bin/bash ./bash
cd ${PKGDIR}/bin && ln -sf ../usr/bin/bash ./sh

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXbash
NAME=${PKGNAME}
DESC=GNU Bourne Again shell 
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

