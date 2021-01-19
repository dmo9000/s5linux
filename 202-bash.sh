#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#

# setup

set -e

die()
{
        echo "$8"
        exit 1

}
. ./build-validator.sh || die "can't locate validator"


BUILDREQUIRES="devel.pkgs"
PKGID=S5LXbash
PKG=bash
VERSION=5.1
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
mkdir -p ${PKGDIR}/bin
cd ${PKGDIR}/bin && ln -sf ../usr/bin/bash ./bash
cd ${PKGDIR}/bin && ln -sf ../usr/bin/bash ./sh

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=GNU Bourne Again shell 
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
