#!/bin/sh
#

# setup
#
set -e
#
# start-stop-daemon
PKGID=S5LXstart-stop-daemon
PKG=start-stop-daemon
VERSION=1.0
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

rm -rf ${PKGDIR}
#./autogen.sh
#./configure --prefix=/usr 
#make  -j ${NPROC}
#make install DESTDIR=${PKGDIR}
#/usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-headrat-linux-gnu -Dman=true -Ddtrace=true -Dsystemtap=true -Dpkg-config_doc=true -Dinstalled_tests=true -Dfam=true --default-library=both
#/usr/bin/meson compile -C x86_64-headrat-linux-gnu -j 4 --verbose
#DESTDIR=${PKGDIR} /usr/bin/meson install -C x86_64-headrat-linux-gnu --no-rebuild

gcc -o start-stop-daemon start-stop-daemon.c
mkdir -p ${PKGDIR}/usr/bin
cp start-stop-daemon ${PKGDIR}/usr/bin/

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=start-stop-daemon
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

#cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
#/sbin/ldconfig
#__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
