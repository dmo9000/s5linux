#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=heirloom-sh-000000
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

make -j ${NPROC} 
sudo make ROOT=${PKGDIR} install

# package

cd ${PKGDIR}

sudo cat <<__PKGINFO__ | sudo tee pkginfo
PKG=S5LXheirloom-sh
NAME=${PKGNAME}
DESC=heirloom-sh
VENDOR=Headrat Linux
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

sudo ../../mkproto.sh

