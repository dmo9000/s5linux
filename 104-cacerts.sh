#!/bin/sh
#

# setup

PKGNAME=cacerts-1.0
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

# configure/build/install

mkdir -p ${PKGDIR}/etc/pki/tls/certs/
cp -rfpv ${TOPLEVEL}/configs/etc/pki/tls/certs/ca-bundle.crt ${PKGDIR}/etc/pki/tls/certs/

cd ${TOPLEVEL}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXcacerts
NAME=${PKGNAME}
DESC=TLS CA Certs
VENDOR=HeadRat Linux
VERSION=1.0
ARCH=x86_64
CATEGORY=libraries
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
