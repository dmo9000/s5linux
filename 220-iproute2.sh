#!/bin/sh
#

# setup

PKGID=S5LXiproute2
PKG=iproute2
VERSION=5.9.0
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
sed -i "s/^check_selinux/## check_selinux/" ./configure
./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=iproute2 network configuration utilities
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
#../../mkstream.sh ${PKGID} 
