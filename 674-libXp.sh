#!/bin/sh
#

# setup
#
set -e
#
# libXp
PKGID=S5LXlibXp
PKG=libXp
VERSION=1.0.3
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

rm -rf ${PKGDIR}
# configure/build/install
./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=libXp
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
/sbin/ldconfig
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
