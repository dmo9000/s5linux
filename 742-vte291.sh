#!/bin/sh
#

# setup
#
set -e
#
# vte2913-2.4.103
PKGID=S5LXvte291
PKG=vte
VERSION=0.62.1
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
#cmake -DCMAKE_INSTALL_PREFIX=/usr .
#./configure --prefix=/usr 
#make -j ${NPROC}
#make DESTDIR=${PKGDIR} install
/usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-headrat-linux-gnu -Dman=true -Ddtrace=true -Dsystemtap=true -Dvte291_doc=true -Dinstalled_tests=true -Dfam=true --default-library=both
/usr/bin/meson compile -C x86_64-headrat-linux-gnu -j ${NPROC} --verbose
DESTDIR=${PKGDIR} /usr/bin/meson install -C x86_64-headrat-linux-gnu --no-rebuild

# package

cd ${PKGDIR}
PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=vte291
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
/sbin/ldconfig
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
