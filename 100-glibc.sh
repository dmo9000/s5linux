#!/bin/sh
#

# setup

PKGID=S5LXglibc
PKG=glibc
VERSION=2.32
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz

# configure/build/install

mkdir -p ../${PKGNAME}-build/
cd ../${PKGNAME}-build/
../src/${PKGNAME}/configure --prefix=/usr
make -j ${NPROC}
make install DESTDIR=${PKGDIR}
cd ${PKGDIR} && ln -sf lib lib64
cd ${TOPLEVEL}

# package

cd ${PKGDIR}

PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=GNU libc
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=libraries
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
/sbin/ldconfig
cd /var/db
/usr/ccs/bin/make -f Makefile
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
