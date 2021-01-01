#!/bin/sh
#

# setup

PKGID=S5LXiputils
PKG=iputils
VERSION=s20200821
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
/usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-redhat-linux-gnu -DBUILD_TFTPD=false 
/usr/bin/meson compile -C x86_64-redhat-linux-gnu -j 4 --verbose
sudo DESTDIR=${PKGDIR} /usr/bin/meson install -C x86_64-redhat-linux-gnu --no-rebuild 
sudo find ${TOPLEVEL}/pkgbuild/iputils-s20200821/ -name "ping" -exec sudo chmod u+s {} \;
# package

cd ${PKGDIR}

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=iputils (ping etc)
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
echo "Setting setuid root on /usr/bin/ping ... "
chmod u+s /usr/bin/ping
__POSTINSTALL__

sudo chmod 755 postinstall

../../mkproto.sh
../../mkpkg.sh
