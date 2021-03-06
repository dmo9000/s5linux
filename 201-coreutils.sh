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
PKGID=S5LXcoreutils
PKG=coreutils
VERSION=8.32
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
rm -rf ${PKGDIR}
mkdir -p ${PKGDIR}

# FIXME should probably use hard links like Redhat does, but I'm too lazy to figure it out right now

./configure --prefix=/ --disable-xattr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

./configure --prefix=/usr --disable-xattr
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}
# remove duplicate manpages
rm -rf ${PKGDIR}/share

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXcoreutils
NAME=${PKGNAME}
DESC=GNU coreutils
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
