#!/bin/sh
#

# setup
#
set -e

die()
{
        echo "$*"
        exit 1

}
. ./build-validator.sh || die "can't locate validator"


#
# cde
BUILDREQUIRES="devel.pkgs X.pkgs CDE.pkgs"
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
#cp ${TOPLEVEL}/CDE.Makefile . 
make CC=gcc Makefile.boot
sed -i "s/^\(\s*CFLAGS =.*\)$/\1 -DPAM/g" xmakefile
make CC=gcc VerifyOS
make CC=gcc -j ${NPROC} Makefiles
make CC=gcc -j ${NPROC} clean
make CC=gcc -j ${NPROC} includes
make CC=gcc -j ${NPROC} depend
make CC=gcc -j ${NPROC} all
make CC=gcc Makefiles.doc
cd doc && make CC=gcc
cd ${TOPLEVEL}/src/${PKGNAME}
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
sudo find ${PKGDIR} -name "fonts.alias" -delete
sudo find ${PKGDIR} -name "sys.font" -delete
sudo find ${PKGDIR} -name "sys.resources" -delete
mkdir -p ${PKGDIR}/usr/dt/config/C/
sudo cp -p ${TOPLEVEL}/configs/usr/dt/config/C/Xresources ${PKGDIR}/usr/dt/config/C/Xresources

sudo mkdir -p ${PKGDIR}/usr/dt/share/backdrops/
sudo cp graphics/dtlogin-logo-256.pm ${PKGDIR}/usr/dt/share/backdrops/dtlogin-logo-256.pm

# default CDE theme

sudo cp ${PKGDIR}/usr/dt/share/palettes/Grass.dp \
	${PKGDIR}/usr/dt/share/palettes/Default.dp

# update icons

sudo mkdir -p ${PKGDIR}/usr/dt/appconfig/icons/C/
sudo cp ${TOPLEVEL}/cde-icons/*.pm ${PKGDIR}/usr/dt/appconfig/icons/C/
sudo cp /dev/null ${PKGDIR}/usr/dt/appconfig/types/C/autoStart.dt
mkdir -p ${PKGDIR}/usr/dt/config/xfonts/C/
sudo cp ${TOPLEVEL}/fonts/win95/*.pcf ${PKGDIR}/usr/dt/config/xfonts/C/
( cd ${PKGDIR}/usr/dt/config/xfonts/C/ && sudo /usr/bin/mkfontdir )
sudo mkdir -p ${PKGDIR}/usr/dt/app-defaults/C/
sudo cp ${TOPLEVEL}/configs/usr/dt/app-defaults/C/Dtwm \
	${PKGDIR}/usr/dt/app-defaults/C/Dtwm

sudo cp ${TOPLEVEL}/configs/usr/dt/appconfig/types/C/dtwm.fp \
	${PKGDIR}/usr/dt/appconfig/types/C/dtwm.fp

sudo cp ${TOPLEVEL}/configs/usr/dt/config/Xsetup \
	${PKGDIR}/usr/dt/config/Xsetup

PSTAMP=`date +"%Y%m%d%H%M%S"`

cd ${PKGDIR}
cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=Common Desktop Environment
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
echo "/usr/dt/lib" >> /etc/ld.so.conf
/sbin/ldconfig
sed -i "s/^.*dtlogin.*$//g" /etc/inittab
echo "5:5:respawn:/usr/dt/bin/dtlogin" >> /etc/inittab
__POSTINSTALL__

../../mkproto.sh
../../mkpkg.sh
