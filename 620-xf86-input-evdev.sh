#!/bin/sh
#

# setup
#
set -e
#
# xf86-input-evdev-2.10.6 
PKGID=S5LXxf86-input-evdev
PKG=xf86-input-evdev
VERSION=2.10.6
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -jxvf ${PKGNAME}.tar.bz2
cd ${PKGNAME} 

# configure/build/install
./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# package

cd ${PKGDIR}



cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=PCI access library
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
