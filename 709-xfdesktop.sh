#!/bin/sh
#

# setup
#
set -e
#
# xfdesktop3-2.4.103
PKGID=S5LXxfdesktop
PKG=xfdesktop
VERSION=4.14.1
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -jxvf ${PKGNAME}.tar.bz2
cd ${PKGNAME} 

# configure/build/install
./configure --prefix=/usr --disable-wayland-backend --enable-x11-backend
make -j ${NPROC}
make DESTDIR=${PKGDIR} install
#/usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-headrat-linux-gnu -Dman=true -Ddtrace=true -Dsystemtap=true -Dxfdesktop_doc=true -Dinstalled_tests=true -Dfam=true --default-library=both
#/usr/bin/meson compile -C x86_64-headrat-linux-gnu -j 4 --verbose
#DESTDIR=${PKGDIR} /usr/bin/meson install -C x86_64-headrat-linux-gnu --no-rebuild

# package

mkdir -p ${PKGDIR}/etc/xdg-test/xfce4/xfconf/xfce-perchannel-xml/
cp ${TOPLEVEL}/configs/etc/xdg-test/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml \
       	${PKGDIR}/etc/xdg-test/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
cp ${TOPLEVEL}/graphics/syslinux.png ${PKGDIR}/usr/share/backgrounds/xfce/xfce-stripes.png

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=xfdesktop
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
