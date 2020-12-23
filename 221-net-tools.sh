#!/bin/sh
#

# setup

PKGID=S5LXnet-tools
PKG=net-tools
VERSION=2.0.20160912git
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
mkdir ${PKGNAME}
cd ${PKGNAME}
tar -xvf ../${PKGNAME}.tar

# configure/build/install
./configure.sh
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=net tools
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
#../../mkstream.sh ${PKGID} 
