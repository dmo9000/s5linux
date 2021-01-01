#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXbzip2
PKG=bzip2
VERSION=1.0.8
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

rm -rf ${PKGDIR} && mkdir -p ${PKGDIR}

make -j ${NPROC} -f Makefile-libbz2_so 
make clean
make -j ${NPROC}
make install PREFIX=${PKGDIR}/usr

mkdir -p ${PKGDIR}/usr/lib64
cp -v bzip2-shared ${PKGDIR}/usr/bin/bzip2
cp -av libbz2.so* ${PKGDIR}/usr/lib
cp -av libbz2.so* ${PKGDIR}/usr/lib64
cd ${PKGDIR}/usr/lib
ln -sv libbz2.so.1.0 libbz2.so
ln -sv libbz2.so.1.0.8 libbz2.so.1
cd ${PKGDIR}/usr/lib64
ln -sv libbz2.so.1.0 libbz2.so
ln -sv libbz2.so.1.0.8 libbz2.so.1
cd ${PKGDIR}/usr/bin
rm -fv ${PKGDIR}/usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 bunzip2
ln -sv bzip2 bzcat

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=bzip2
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
