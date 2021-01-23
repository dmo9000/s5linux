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
PKGID=S5LXed
PKG=ed
VERSION=1.17
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
rm -rf ${PKGDIR}
lzip -f -k -d ${PKGNAME}.tar.lz
tar -xvf ${PKGNAME}.tar
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
DESC=GNU ed
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
