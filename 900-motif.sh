#!/bin/sh
#

# setup
#
set -e
#
# motif
PKGID=S5LXmotif
PKG=motif
VERSION=2.3.8
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
rm -rf ${TOPLEVEL}/src/${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

rm -rf ${PKGDIR}

for PATCH in `ls -1 ${TOPLEVEL}/patches/motif/*.patch` ; do 
	echo "PATCH = ${PATCH}"
	cd $TOPLEVEL/src/$PKGNAME && patch -p1 < ${PATCH} 
	done

#./autogen.sh
sed -i '1s/^/%option main\n/' tools/wml/wmluiltok.l
./configure --prefix=/usr --enable-xft 
ln -sf /usr/bin/aclocal ./aclocal-1.15
ln -sf /usr/bin/automake ./automake-1.15
PATH=$PATH:`pwd`
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
#/usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-headrat-linux-gnu -Dman=true -Ddtrace=true -Dsystemtap=true -Dpkg-config_doc=true -Dinstalled_tests=true -Dfam=true --default-library=both
#/usr/bin/meson compile -C x86_64-headrat-linux-gnu -j 4 --verbose
#DESTDIR=${PKGDIR} /usr/bin/meson install -C x86_64-headrat-linux-gnu --no-rebuild

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=motif
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
