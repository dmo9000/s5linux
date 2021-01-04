#!/bin/sh
#

# setup
#
set -e
#
# cde
PKGID=S5LXcde
PKG=cde
VERSION=2.3.2
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
rm -rf ${TOPLEVEL}/src/${PKGNAME}
rm -rf ${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

rm -rf ${PKGDIR}

#for PATCH in `ls -1 ${TOPLEVEL}/patches/cde/*.patch` ; do 
#	echo "PATCH = ${PATCH}"
#	cd $TOPLEVEL/src/$PKGNAME && patch -p1 < ${PATCH} 
#	done

#./autogen.sh
#./configure --prefix=/usr --enable-xft 
#ln -sf /usr/bin/aclocal ./aclocal-1.15
#ln -sf /usr/bin/automake ./automake-1.15
#PATH=$PATH:`pwd`
make  World 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
cp programs/dtlogin/config/{Xsession,Xsetup,Xstartup,Xreset,Xfailsafe} ${PKGDIR}/usr/dt/bin/
# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=cde
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
