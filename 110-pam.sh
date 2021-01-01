#!/bin/sh
set -e
#

# setup

PKGNAME=Linux-PAM-1.4.0
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME}

# configure/build/install


./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --libdir=/usr/lib                \
            --enable-securedir=/lib/security \
            --disable-selinux \
            --docdir=/usr/share/doc/Linux-PAM-1.4.0
make clean
make -j ${NPROC}
make install DESTDIR=${PKGDIR}
cd ${TOPLEVEL}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXpam
NAME=${PKGNAME}
DESC=Linux PAM
VENDOR=HeadRat Linux
VERSION=000000
ARCH=x86_64
CATEGORY=libraries
BASEDIR=/
__PKGINFO__

../../mkproto.sh
