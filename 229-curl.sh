#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXcurl
PKG=curl
VERSION=7.74.0
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -xvf ${PKGNAME}.tar
cd ${PKGNAME} 

./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=curl
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
