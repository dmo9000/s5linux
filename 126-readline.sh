#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXreadline
PKG=readline
VERSION=8.0
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

#for mfile in $(find "$PWD" -name 'Makefile'); do
#    sed -i 's|SHLIB_LIBS =|SHLIB_LIBS = -ltinfo|g' "$mfile"
#done

# SHLIB_LIBS="-ltinfo" ./configure --prefix=/usr 
./configure --prefix=/usr  --with-curses 
make  -j ${NPROC} SHLIB_XLDFLAGS=-lncurses
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=GNU readline 
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
