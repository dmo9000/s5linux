#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXkernel-headers
PKG=kernel-headers
VERSION=5.10.1
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/build/${PKG}

cd build/kernel-headers 

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=Linux Kernel Headers ${VERSION}
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
