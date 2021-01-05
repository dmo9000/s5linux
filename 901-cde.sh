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
sudo rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

sudo rm -rf ${PKGDIR}

echo "#define UsrLibDir /usr/lib64" > config/cf/host.def
make  World.dev 
make install DESTDIR=${PKGDIR}
cp programs/dtlogin/config/{Xsession,Xsetup,Xstartup,Xreset,Xfailsafe} ${PKGDIR}/usr/dt/bin/
mkdir ${PKGDIR}/usr/dt/palettes
cp programs/palettes/Default.dp ${PKGDIR}/usr/dt/palettes/Default.dp

cd ${TOPLEVEL}
set +e
./install-cde.sh
set -e

cd ${PKGDIR}
cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=CDE
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
echo "/usr/dt/lib" >> /etc/ld.so.conf
/sbin/ldconfig
__POSTINSTALL__

../../mkproto.sh
../../mkpkg.sh
