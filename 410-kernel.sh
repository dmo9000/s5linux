#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXkernel
PKG=kernel
VERSION=5.10.1
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/build/${PKG}

mkdir -p pkgbuild/kernel/boot
chmod 755 pkgbuild/kernel/boot
cp kernel/bzImage pkgbuild/kernel/boot/bzImage
cd pkgbuild/kernel

# package

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=Linux Kernel ${VERSION}
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
