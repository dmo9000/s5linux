#!/bin/sh
#

# setup
#
set -e
#
# fvwm2
PKGID=S5LXfvwm2
PKG=fvwm
VERSION=2.6.9
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
./configure --prefix=/usr --disable-mandoc --disable-sm --disable-shape --disable-shm --disable-xinerama --disable-xrender --disable-xcursor --disable-xft --disable-fontconfigtest --disable-xfttest --disable-png --disable-rsvg --disable-iconv --disable-bidi --disable-perllib --disable-nls --disable-imlibtest
 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=fvwm2
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
rm -f /root/.xinitrc
echo "/usr/bin/xterm &" >> /root/.xinitrc
echo "/usr/bin/fvwm2" >> /root/.xinitrc
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
