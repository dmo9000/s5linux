#!/bin/sh
#

# setup
#
set -e
#
# systemd-247 
PKGID=S5LXsystemd
PKG=systemd
VERSION=247
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
#./configure --prefix=/usr 
./configure --prefix=/usr -Dselinux=false
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}

# install SysV init script for udev

mkdir -p ${PKGDIR}/etc/init.d
mkdir -p ${PKGDIR}/etc/rc5.d
cp ${TOPLEVEL}/configs/etc/init.d/udevd ${PKGDIR}/etc/init.d/udevd
cd ${PKGDIR}/etc/rc5.d 
ln -sf ../init.d/udevd ./S01udevd

# package

cd ${PKGDIR}



cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=systemd
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
