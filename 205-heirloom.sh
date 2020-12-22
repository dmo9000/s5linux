#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=heirloom-040306
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

make  
sudo make ROOT=${PKGDIR} install
sudo rm -f ${PKGDIR}/var/log/sulog

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXheirloom-tools
NAME=${PKGNAME}
DESC=heirloom-tools
VENDOR=HeadRat Linux
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

