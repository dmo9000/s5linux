#!/bin/sh
#

# setup
#
set -e
#


PKGID=S5LXrpcbind
PKG=rpcbind
VERSION=1.2.5
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -jxvf ${PKGNAME}.tar.bz2
cd ${PKGNAME} 
#./autogen.sh
./configure --prefix=/
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

mkdir -p ${PKGDIR}/etc/{init.d,rc0.d,rc5.d}
cp ${TOPLEVEL}/lfs-bootscripts/blfs-bootscripts-20201002/blfs/init.d/rpcbind \
	${PKGDIR}/etc/init.d/rpcbind
chmod 755 ${PKGDIR}/etc/init.d/rpcbind

cd ${PKGDIR}/etc/rc0.d/ && sudo ln -sf ../init.d/rpcbind ./K85rpcbind
cd ${PKGDIR}/etc/rc5.d/ && sudo ln -sf ../init.d/rpcbind ./S15rpcbind

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=rpcbind
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
