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
echo "#define UsrLibDir /usr/lib64" > config/cf/host.def
make  World.dev 
#make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
cp programs/dtlogin/config/{Xsession,Xsetup,Xstartup,Xreset,Xfailsafe} ${PKGDIR}/usr/dt/bin/
mkdir ${PKGDIR}/usr/dt/palettes
cp programs/palettes/Default.dp ${PKGDIR}/usr/dt/palettes/Default.dp

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

../../mkproto.sh
../../mkpkg.sh

cd ${TOPLEVEL}
set +e
./install-cde.sh
set -e
cd ${PKGDIR}-configs

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}-configs
NAME=${PKGNAME} configs 
DESC=cde
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
