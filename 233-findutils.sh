#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXfindutils
PKG=findutils
VERSION=4.8.0
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -xvf ${PKGNAME}.tar
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
DESC=GNU findutils
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
