#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXgdb
PKG=gdb
VERSION=10.1
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 
./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

find ${PKGDIR} -type f -name "updatedb*" -exec rm -f {} \;
find ${PKGDIR} -type f -name "locate*" -exec rm -f {} \;

# package

cd ${PKGDIR}
PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=GNU gdb
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
