#!/bin/sh
set -e
#
die()
{
        echo "$*"
        exit 1

}
. ./build-validator.sh || die "can't locate validator"


BUILDREQUIRES="devel.pkgs"
PKGID=S5LXpam
PKG=Linux-PAM
VERSION=1.4.0
PKGNAME=${PKG}-${VERSION}
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
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=libraries
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
