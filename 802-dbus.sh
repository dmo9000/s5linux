#!/bin/sh
#

# setup
#
set -e
#
# dbus-1.0.9

PKGID=S5LXdbus
PKG=dbus
VERSION=1.12.20
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
./configure --prefix=/usr --disable-systemd -with-dbus-user=dbus 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

mkdir -p ${PKGDIR}/etc/init.d
mkdir -p ${PKGDIR}/etc/rc5.d
cp ${TOPLEVEL}/configs/etc/init.d/dbus ${PKGDIR}/etc/init.d/dbus
cd ${PKGDIR}/etc/rc5.d
ln -sf ../init.d/dbus ./S05dbus


# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=dbus 
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
