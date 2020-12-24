#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXopenssh
PKG=openssh
VERSION=8.4p1
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}

cd src
sudo rm -rf ./${PKGNAME}
sudo rm -rf ${PKGDIR}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

./configure --prefix=/usr 
make  -j ${NPROC}
make install DESTDIR=${PKGDIR}
sudo mkdir -p ${PKGDIR}/etc/init.d/
sudo mkdir -p ${PKGDIR}/etc/rc5.d/
sudo cp ${TOPLEVEL}/configs/etc/init.d/sshd ${PKGDIR}/etc/init.d/sshd
cd ${PKGDIR}/etc/rc5.d/ && sudo ln -sf ../init.d/sshd ./S10sshd

# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=OpenSSH
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=IA64,x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
/etc/init.d/sshd start
__POSTINSTALL__

sudo chmod 755 postinstall


../../mkproto.sh
../../mkpkg.sh
