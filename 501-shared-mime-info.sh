#!/bin/sh
#

# setup
#
set -e
#
# shared-mime-info
PKGID=S5LXshared-mime-info
PKG=shared-mime-info
VERSION=2.1
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
#xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -xxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

rm -rf ${PKGDIR}
# configure/build/install
#./configure --prefix=/usr 
#make  -j ${NPROC}
#make install DESTDIR=${PKGDIR}
/usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-headrat-linux-gnu -Dman=true -Ddtrace=true -Dsystemtap=true -Dpkg-config_doc=true -Dinstalled_tests=true -Dfam=true --default-library=both
/usr/bin/meson compile -C x86_64-headrat-linux-gnu -j 4 --verbose
DESTDIR=${PKGDIR} /usr/bin/meson install -C x86_64-headrat-linux-gnu --no-rebuild


# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=shared-mime-info
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
/sbin/ldconfig
update-mime-database /usr/share/mime 
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
