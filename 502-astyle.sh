#!/bin/sh
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
PKGID=S5LXastyle
PKG=astyle
VERSION=3.1
PKGNAME=${PKG}_${VERSION}_linux
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src 
rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKG} 

# configure/build/install

cmake . 
make -j ${NPROC}
make DESTDIR=${PKGDIR} install

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=astyle
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
