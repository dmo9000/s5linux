#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXlibjpeg-turbo
PKG=libjpeg-turbo
VERSION=2.0.6
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

#./configure --prefix=/usr 
cmake -G"Unix Makefiles"
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}


# package

cd ${PKGDIR}

# honestly some people need to get a grip ...

mv opt usr
mv usr/libjpeg-turbo/* usr
rmdir usr/libjpeg-turbo



cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=libjpeg-turbo
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
