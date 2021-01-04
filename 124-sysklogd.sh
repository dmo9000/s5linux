#!/bin/sh
#

# setup
#
set -e
#


PKGID=S5LXsysklogd
PKG=sysklogd
VERSION=1.0
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 
./autogen.sh
./configure --prefix=/usr
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
mkdir -p ${PKGDIR}/etc
cp ${TOPLEVEL}/configs/etc/syslog.conf ${PKGDIR}/etc/syslog.conf

mkdir -p ${PKGDIR}/etc/{init.d,rc0.d,rc5.d}
cp ${TOPLEVEL}/configs/etc/init.d/sysklogd \
	${PKGDIR}/etc/init.d/sysklogd
chmod 755 ${PKGDIR}/etc/init.d/sysklogd

cd ${PKGDIR}/etc/rc0.d/ && sudo ln -sf ../init.d/sysklogd ./K99sysklogd
cd ${PKGDIR}/etc/rc5.d/ && sudo ln -sf ../init.d/sysklogd ./S02sysklogd

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=sysklogd
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
