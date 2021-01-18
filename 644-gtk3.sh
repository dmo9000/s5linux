#!/bin/sh
#

# setup
#
set -e
#
# gtk3-2.4.103
PKGID=S5LXgtk3+
PKG=gtk+
VERSION=3.24.24
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
./configure --prefix=/usr --disable-wayland-backend --enable-x11-backend
make -j ${NPROC}
make DESTDIR=${PKGDIR} install

# package

sudo mkdir -p ${PKGDIR}/usr/share/gtk-3.0/
sudo cp ${TOPLEVEL}/configs/usr/share/gtk-3.0/settings.ini ${PKGDIR}/usr/share/gtk-3.0/settings.ini

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=gtk3+
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
