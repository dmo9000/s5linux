#!/bin/sh
#
# mount/wall disabllzip for now since it wants to chggrp
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
PKGID=S5LXautopkg
PKG=s5devel
VERSION=`date +"%Y%m%d%H%M%S"`
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
git clone https://github.com/dmo9000/s5devel ${PKGNAME}
cd ${PKGNAME}/autopkg 

# configure/build/install

make 

# package

mkdir -p ${PKGDIR}/usr/bin

cp -p autopkg ${PKGDIR}/usr/bin/autopkg

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=GNU lzip
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh

rm -rf ${PKGDIR}
rm -rf ${TOPLEVEL}/src/${PKGNAME}
