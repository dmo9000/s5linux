#!/bin/sh
#

# setup
#
set -e
#
# NetworkManager-1.0.9

PKGID=S5LXNetworkManager
PKG=NetworkManager
VERSION=1.26.4
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

# FIXME: need libpcre packaged
./configure --prefix=/usr --disable-ovs --with-crypto=gnutls --enable-ifcfg-rh --enable-ifupdown --enable-lto --disable-wifi --disable-qt --disable-ppp --enable-modify-system
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

mkdir -p ${PKGDIR}/etc/init.d
cp ${TOPLEVEL}/lfs-bootscripts/blfs-bootscripts-20201002/blfs/init.d/networkmanager ${PKGDIR}/etc/init.d/networkmanager

# package

cd ${PKGDIR}
PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=NetworkManager 
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
