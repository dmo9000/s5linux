#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXlibcap
PKG=libcap
VERSION=2.46
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -axvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
make
make DESTDIR=${PKGDIR} RAISE_SETFCAP=no lib=lib prefix=/usr install

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=libcap
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
