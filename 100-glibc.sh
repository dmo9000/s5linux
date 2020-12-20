#!/bin/sh
#

# setup

PKGNAME=glibc-2.32
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz

# configure/build/install

cd ../build/
../src/${PKGNAME}/configure --prefix=/
make -j ${NPROC}
make install DESTDIR=${PKGDIR}
cd ${PKGDIR} && ln -sf lib lib64
cd ${TOPLEVEL}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXglibc
NAME=${PKGNAME}
DESC=GNU libc
VENDOR=Headrat Linux
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=libraries
BASEDIR=/
__PKGINFO__

../../mkproto.sh
