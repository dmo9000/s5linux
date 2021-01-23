#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=heirloom-pkgtools-000000
PKG=heirloom-pkgtools
VERSION=1.0
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
#sed -i "s/^CFLAGS=.*/CFLAGS=-static/g" mk.config
#sed -i "s/^LDFLAGS=.*/LDFLAGS=-static/g" mk.config

make -j ${NPROC} 
sudo make ROOT=${PKGDIR} install

# package

cd ${PKGDIR}

sudo cat <<__PKGINFO__ | sudo tee pkginfo
PKG=S5LXheirloom-pkgtools
NAME=${PKGNAME}
DESC=heirloom-pkgtools
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

sudo ../../mkproto.sh
sudo ../../mkpkg.sh

