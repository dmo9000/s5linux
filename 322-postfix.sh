#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXpostfix
PKG=postfix
VERSION=3.5.8
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
sudo rm -rf ./${PKGNAME}
#xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
#./configure --prefix=/usr 
AUXLIBS="-ldb -lnsl -lresolv" CFLAGS="-DNO_NIS -DNO_NISPLUS" make makefiles
AUXLIBS="-ldb -lnsl -lresolv" CFLAGS="-DNO_NIS -DNO_NISPLUS" make 
AUXLIBS="-ldb -lnsl -lresolv" CFLAGS="-DNO_NIS -DNO_NISPLUS" make install install_root=${PKGDIR}

sudo mkdir -p ${PKGDIR}/etc/init.d
sudo cp ${TOPLEVEL}/lfs-bootscripts/blfs-bootscripts-20201002/blfs/init.d/postfix ${PKGDIR}/etc/init.d/postfix

# package

cd ${PKGDIR}

PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=postfixutils
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
