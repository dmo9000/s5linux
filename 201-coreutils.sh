#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

PKGNAME=coreutils-8.32
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
rm -rf ${PKGDIR}
mkdir -p ${PKGDIR}

./configure --prefix=/ 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

mkdir -p  ${PKGDIR}/usr/bin
cd ${PKGDIR}/usr/bin
ln -sf ../../bin/tr tr

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXcoreutils
NAME=${PKGNAME}
DESC=GNU coreutils
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh


# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXcoreutils
NAME=${PKGNAME}
DESC=GNU coreutils
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

