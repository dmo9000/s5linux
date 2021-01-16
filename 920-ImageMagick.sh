#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXImageMagick
PKG=ImageMagick
VERSION=7.0.10-57
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# FIXME: need libpcre packaged
./configure --prefix=/usr  
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

#mkdir -p ${PKGDIR}/etc/init.d
#mkdir -p ${PKGDIR}/etc/rc5.d
#cp ${TOPLEVEL}/configs/etc/init.d/ImageMagick ${PKGDIR}/etc/init.d/ImageMagick
#cd ${PKGDIR}/etc/rc5.d
#ln -sf ../init.d/ImageMagick ./S05ImageMagick


# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=ImageMagick 
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
