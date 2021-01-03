#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup
set -e

PKGNAME=sysvinit-2.98
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

make  -j ${NPROC}
make install ROOT=${PKGDIR}

mkdir -p ${PKGDIR}/lib/lsb/
cp ${TOPLEVEL}/configs/lib/lsb/init-functions ${PKGDIR}/lib/lsb/init-functions

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXsysvinit
NAME=${PKGNAME}
DESC=SysV Init
VENDOR=HeadRat Linux
VERSION=2.98
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh

