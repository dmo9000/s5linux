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
PKGID=S5LXvim
PKG=vim
VERSION=8.1
PKGNAME="${PKG}-${VERSION}"
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install

./configure --prefix=/usr --enable-gui=no --without-x --disable-selinux 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
cd ${PKGDIR}/usr/bin
ln -sf vim vi

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=vim editor
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
