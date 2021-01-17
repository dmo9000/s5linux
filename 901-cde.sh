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
make Makefiles.doc
cd doc && make
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

sudo cp ${PKGDIR}/usr/dt/share/palettes/Grass.dp ${PKGDIR}/usr/dt/share/palettes/Default.dp

# update icons

sudo cp ${TOPLEVEL}/cde-icons/*.pm /usr/dt/appconfig/icons/C/

# sudo find ${PKGDIR} -name "DtMail.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/mail-send-receive.png {} \;
# sudo find ${PKGDIR} -name "Dtterm.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/utilities-terminal.png {} \;
# sudo find ${PKGDIR} -name "Fppenpd.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/accessories-text-editor.png {} \;
# sudo find ${PKGDIR} -name "Fpprnt.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/printer-printing.png {} \;
# sudo find ${PKGDIR} -name "Fphome.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/system-file-manager.png {} \;
#sudo find ${PKGDIR} -name "Dtinfo.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/system-help.png {} \;
#sudo find ${PKGDIR} -name "Fptrsh.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/places/user-trash.png {} \;
#sudo find ${PKGDIR} -name "Fpapps.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/applications-other.png {} \;
#sudo find ${PKGDIR} -name "Fpstyle.l.pm" -print -exec convert -layers Optimize /usr/share/icons/Adwaita/48x48/legacy/preferences-desktop-theme.png {} \;

sudo cp /dev/null ${PKGDIR}/usr/dt/appconfig/types/C/autoStart.dt

#sudo convert /usr/share/icons/Adwaita/48x48/legacy/mail-send-receive.png /usr/dt/appconfig/icons/C/DtMail.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/legacy/utilities-terminal.png /usr/dt/appconfig/icons/C/Dtterm.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/legacy/accessories-text-editor.png /usr/dt/appconfig/icons/C/Fppenpd.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/legacy/printer-printing.png /usr/dt/appconfig/icons/C/Fpprnt.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/legacy/system-file-manager.png /usr/dt/appconfig/icons/C/Fphome.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/legacy/system-help.png /usr/dt/appconfig/icons/C/Dtinfo.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/places/user-trash.png /usr/dt/appconfig/icons/C/Fptrsh.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/legacy/applications-other.png /usr/dt/appconfig/icons/C/Fpapps.l.pm
#sudo convert /usr/share/icons/Adwaita/48x48/legacy/preferences-desktop-theme.png /usr/dt/appconfig/icons/C/Fpstyle.l.pm

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
