#!/bin/sh
#
# mount/wall disabled for now since it wants to chggrp
#
# setup

PKGNAME=libxcrypt-4.4.17
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 
patch -p1 < ../../patches/libxcrypt-4.4.17-enable_LTO_build.patch

# configure/build/install

./autogen.sh
./configure -build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu --program-prefix= --disable-dependency-tracking --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man --infodir=/usr/share/info --disable-failure-tokens --disable-silent-rules --enable-shared --enable-static --disable-valgrind --srcdir=/home/dan/rpmbuild/BUILD/libxcrypt-4.4.17 --with-pkgconfigdir=/usr/lib64/pkgconfig --enable-hashes=all --enable-obsolete-api=no --enable-obsolete-api-enosys=no
make 
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=S5LXlibxcrypt
NAME=${PKGNAME}
DESC=libxcrypt
VENDOR=HeadRat Linux
VERSION=000000
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh

