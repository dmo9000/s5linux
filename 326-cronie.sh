#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXcronie
PKG=cronie
VERSION=1.5.5
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
./configure --prefix=/usr 
make -j ${NPROC} 
make DESTDIR=${PKGDIR} install
sudo mkdir -p ${PKGDIR}/etc/init.d
sudo mkdir -p ${PKGDIR}/etc/rc0.d
sudo mkdir -p ${PKGDIR}/etc/rc5.d
sudo mkdir -p ${PKGDIR}/etc/rc6.d

sudo cp ${TOPLEVEL}/lfs-bootscripts/blfs-bootscripts-20201002/blfs/init.d/crond \
	${PKGDIR}/etc/init.d/crond
sudo chmod 755 ${PKGDIR}/etc/init.d/crond
( cd ${PKGDIR}/etc/rc5.d && sudo ln -sf ../init.d/crond ./S30crond )
sudo mkdir -p ${PKGDIR}/var/spool/cron
sudo chmod 700 ${PKGDIR}/var/spool/cron

# package

cd ${PKGDIR}

PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=cronie
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
