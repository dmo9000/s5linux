#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup
set -e

die()
{
        echo "$*"
        exit 1

}
. ./build-validator.sh || die "can't locate validator"

BUILDREQUIRES="devel.pkgs"
PKGID=S5LXgcc
PKG=gcc
VERSION=10.2.0
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
mkdir -p build/${PKGNAME}
rm -rf build/${PKGNAME}/*
cd build/${PKGNAME}


# configure/build/install

../../${PKGNAME}/configure --prefix=/usr  --enable-languages=c,c++ --disable-multilib 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

mkdir ${PKGDIR}/lib
cd ${PKGDIR}/lib && ln -sf ../usr/bin/cpp ./cpp

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXgcc
NAME=${PKGNAME}
DESC=GNU Compiler Collection
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
