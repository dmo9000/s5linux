#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXbindutils
PKG=bind
VERSION=9.16.10
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
./configure --prefix=/usr --without-python
make -j ${NPROC} -C lib/dns    
make -j ${NPROC} -C lib/isc    
make -j ${NPROC} -C lib/bind9  
make -j ${NPROC} -C lib/isccfg 
make -j ${NPROC} -C lib/irs   
make -j ${NPROC} -C bin/dig    
make -j ${NPROC} -C doc
make -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=bindutils
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
