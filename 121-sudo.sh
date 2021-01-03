#!/bin/sh
#

# setup
#
set -e
#
# sudo
PKGID=S5LXsudo
PKG=sudo
VERSION=1.9.4p2
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

sudo rm -rf ${PKGDIR}
./configure --prefix=/usr 
make  -j ${NPROC}
sudo make install DESTDIR=${PKGDIR}
cd ${TOPLEVEL}
sudo mkdir -p ${PKGDIR}/etc/pam.d
sudo cp configs/etc/pam.d/sudo ${PKGDIR}/etc/pam.d/sudo
sudo cp configs/etc/pam.d/sudo-i ${PKGDIR}/etc/pam.d/sudo-i

# package

cd ${PKGDIR}

sudo cat <<__PKGINFO__ | sudo tee pkginfo
PKG=${PKGID}
NAME=${PKGNAME} utilities
DESC=sudo
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

sudo chmod 777 ${PKGDIR}
sudo chmod 664 ${PKGDIR}/etc/sudoers
sudo rm -f ${PKGDIR}/etc/sudoers.dist

sudo cat <<__POSTINSTALL__ | sudo tee postinstall
#!/bin/sh
chmod 440 /etc/sudoers
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
