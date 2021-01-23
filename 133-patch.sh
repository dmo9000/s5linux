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
PKGID=S5LXpatch
PKG=patch
VERSION=2.7
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

build_require autoreconf

cd src
rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./configure --prefix=/usr
make 
make DESTDIR=${PKGDIR} install

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=GNU patch
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
