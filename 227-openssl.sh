#!/bin/sh
#

# setup
#
set -e
die()
{
        echo "$*"
        exit 1

}
. ./build-validator.sh || die "can't locate validator"

#
BUILDREQUIRES="devel.pkgs"
PKGID=S5LXopenssl
PKG=openssl
VERSION=1.1.1i
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
rm -rf ${PKGDIR}
mkdir -p ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
./Configure linux-x86_64 --prefix=/usr
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=openssl
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
