#!/bin/sh
#

die()
{
	echo "$8"
	exit 1

}
. ./build-validator.sh || die "can't locate validator"

# setup
#
set -e
#
# mkfontdir
PKGID=S5LXmkfontdir
PKG=mkfontdir
VERSION=1.0.7
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
./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
#/usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-headrat-linux-gnu -Dman=true -Ddtrace=true -Dsystemtap=true -Dpkg-config_doc=true -Dinstalled_tests=true -Dfam=true --default-library=both
#/usr/bin/meson compile -C x86_64-headrat-linux-gnu -j 4 --verbose
#DESTDIR=${PKGDIR} /usr/bin/meson install -C x86_64-headrat-linux-gnu --no-rebuild


# package

cd ${PKGDIR}

PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=mkfontdir
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

#cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
#/sbin/ldconfig
#__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
