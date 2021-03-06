#!/bin/sh
#

# setup

PKGNAME=ncurses-6.2
PKG=ncurses
VERSION=6.2
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz

# configure/build/install

cd ../build/
../src/${PKGNAME}/configure --prefix=/usr --with-termlib --with-shared --enable-widec
make -j ${NPROC}
make install DESTDIR=${PKGDIR}
cd ${TOPLEVEL}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXncurses
NAME=${PKGNAME}
DESC=GNU ncurses
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=libraries
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
