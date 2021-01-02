#!/bin/sh
#

# setup
#
set -e
#
# xinput
PKGID=S5LXxinput
PKG=xinput
VERSION=1.6.3
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
DESC=xinput
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
echo "/usr/bin/xinput" >> /root/.xinitrc
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
