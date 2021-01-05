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

if [ ! -d "${TOPLEVEL}/install-root" ]; then
	echo "install-root/ is missing. Please fix this first." 
	exit 1
	fi

cd src
sudo rm -rf ./${PKGNAME}
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

sudo rm -rf ${PKGDIR}

echo "#define UsrLibDir /usr/lib64" > config/cf/host.def

#make World.dev
cp ${TOPLEVEL}/CDE.Makefile . 
make Makefile.boot
make VerifyOS
make -j ${NPROC} Makefiles
make -j ${NPROC} clean
make -j ${NPROC} includes
make -j ${NPROC} depend
make -j ${NPROC} all

make install DESTDIR=${PKGDIR}
cp programs/dtlogin/config/{Xsession,Xsetup,Xstartup,Xreset,Xfailsafe} ${PKGDIR}/usr/dt/bin/
mkdir ${PKGDIR}/usr/dt/palettes
cp programs/palettes/Default.dp ${PKGDIR}/usr/dt/palettes/Default.dp

cd ${TOPLEVEL}
set +e
./install-cde.sh
set -e

#sudo rm -f ${PKGDIR}/usr/dt/share/backdrops/*.pm
sudo cp ${TOPLEVEL}/graphics/Headrat.pm ${PKGDIR}/usr/dt/share/backdrops/Headrat.pm 
sudo mkdir -p ${PKGDIR}/etc/dt/appconfig/types/C
sudo cp ${TOPLEVEL}/configs/etc/dt/appconfig/types/C/dt.dt \
	${PKGDIR}/etc/dt/appconfig/types/C/dt.dt


sudo rm -f ${PKGDIR}//usr/dt/share/backdrops/*
sudo cp configs/usr/dt/share/backdrops/* ${PKGDIR}/usr/dt/share/backdrops/
sudo find ${PKGDIR}/usr/dt/app-defaults -type f | xargs sudo sed -i "s/SkyLight/Background/g"


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
