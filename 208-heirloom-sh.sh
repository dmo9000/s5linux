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
PKGID=S5LXheirloom-sh
PKG=heirloom-sh
VERSION=1.0
PKGNAME=heirloom-sh-000000
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

make -j ${NPROC} CC=gcc 
sudo make ROOT=${PKGDIR} install

# package

cd ${PKGDIR}

sudo cat <<__PKGINFO__ | sudo tee pkginfo
PKG=S5LXheirloom-sh
NAME=${PKGNAME}
DESC=heirloom-sh
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
