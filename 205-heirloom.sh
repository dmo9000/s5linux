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
PKGID=S5LXheirloom-tools
PKG=heirloom
VERSION=040306
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

make CC=gcc LDFLAGS=-ltinfo 
sudo make ROOT=${PKGDIR} install
sudo rm -f ${PKGDIR}/var/log/sulog

# package

cd ${PKGDIR}

cat <<__PKGINFO__ | sudo tee pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=heirloom-tools
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
