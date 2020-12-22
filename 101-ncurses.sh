#!/bin/sh
#

# setup

PKGNAME=ncurses-6.2
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz

# configure/build/install

cd ../build/
../src/${PKGNAME}/configure --prefix=/ --with-termlib --with-shared
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
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=libraries
BASEDIR=/
__PKGINFO__

../../mkproto.sh
