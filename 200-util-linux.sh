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
PKGID=S5LXutillinux
PKG=util-linux
VERSION=2.36
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
sudo rm -rf ${PKGDIR}
./configure --prefix=/usr  --disable-selinux
make -j ${NPROC}
sudo make install DESTDIR=${PKGDIR}
cd ${TOPLEVEL}
sudo mkdir -p ${PKGDIR}/etc/pam.d
sudo cp configs/etc/pam.d/login ${PKGDIR}/etc/pam.d/login
sudo cp configs/etc/pam.d/su ${PKGDIR}/etc/pam.d/su

sudo chmod 777 ${PKGDIR}

# package

cd ${PKGDIR}

sudo cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=Linux utilities
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
