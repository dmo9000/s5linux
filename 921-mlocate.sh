#!/bin/sh
#

# setup
#
set -e
#
# mlocate-1.0.9

PKGID=S5LXmlocate
PKG=mlocate
VERSION=0.26
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -xvf ${PKGNAME}.tar
cd ${PKGNAME} 

./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
mkdir ${PKGDIR}/etc
cp ${TOPLEVEL}/configs/etc/updatedb.conf ${PKGDIR}/etc/updatedb.conf

# package

cd ${PKGDIR}
PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=mlocate 
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
