#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXkmod
PKG=kmod
VERSION=27
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz

cd ${TOPLEVEL}/src/${PKGNAME}
./configure --prefix=/
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
cd ${PKGDIR}
mkdir -p sbin
cd sbin
ln -sf ../bin/kmod depmod
ln -sf ../bin/kmod insmod
ln -sf ../bin/kmod modinfo
ln -sf ../bin/kmod modprobe
ln -sf ../bin/kmod rmmod
ln -sf ../bin/kmod lsmod

cd ${TOPLEVEL}/src/${PKGNAME}
./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
cd ${PKGDIR}
mkdir -p usr/sbin
cd usr/sbin
ln -sf ../bin/kmod depmod 
ln -sf ../bin/kmod insmod
ln -sf ../bin/kmod modinfo
ln -sf ../bin/kmod modprobe
ln -sf ../bin/kmod rmmod
ln -sf ../bin/kmod lsmod

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=kmod 
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
