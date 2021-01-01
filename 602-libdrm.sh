#!/bin/sh
#

# setup
#
set -e
#
# libdrm-2.4.103
PKGID=S5LXlibdrm
PKG=libdrm
VERSION=2.4.103
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -xvf ${PKGNAME}.tar
cd ${PKGNAME} 

# configure/build/install
rm -rf ../pkgbuild/${PKGNAME}
meson ../pkgbuild/${PKGNAME}/
meson configure ../pkgbuild/${PKGNAME}/ -Dprefix=/usr
DESTDIR=${TOPLEVEL}/pkgbuild/libdrm-2.4.103 ninja -C ../pkgbuild/libdrm-2.4.103 install

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=libdrm
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
