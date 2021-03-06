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
PKGID=S5LXgit
PKG=git
VERSION=2.29.2
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -xvf ${PKGNAME}.tar
cd ${PKGNAME} 

# configure/build/install
./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# tests to check for essential artifacts

[ -r ${PKGDIR}/usr/libexec/git-core/git-remote-https ] || exit 1

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=git
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
