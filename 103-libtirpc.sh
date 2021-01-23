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
PKGID=S5LXlibtirpc
PKG=libtirpc
VERSION=1.2.6
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./configure --prefix=/usr --disable-gssapi --sysconfdir=/etc 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}


# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=libtirpc
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
