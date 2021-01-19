#!/bin/sh
set -e


die()
{
	echo "$*"
	exit 1
}

INSTALL_ROOT="${1}"
[ ! -z "${INSTALL_ROOT}" ] || die "Install root not specified." 

sudo mkdir -p ${INSTALL_ROOT}/etc
sudo mkdir -p ${INSTALL_ROOT}/root
sudo mkdir -p ${INSTALL_ROOT}/var/sadm/install
sudo touch ${INSTALL_ROOT}/var/sadm/install/contents
sudo mkdir -p ${INSTALL_ROOT}/libx32
sudo mkdir -p ${INSTALL_ROOT}/usr/libx32

# sudo cp configs/bashrc ${INSTALL_ROOT}/root/.bashrc
# sudo cp configs/bashrc ${INSTALL_ROOT}/root/.profile
# sudo cp configs/bashrc ${INSTALL_ROOT}/root/.bash_profile

# FIXME: do something better here
#        especially the sshd user setup should be moved to the S5LXopenssh postinstall script

sudo cp configs/etc/profile ${INSTALL_ROOT}/etc/profile
sudo cp configs/etc/shells ${INSTALL_ROOT}/etc/shells


sudo egrep "^bin|^root|^dan|^sshd|^dbus|^nobody" /etc/passwd | tee configs/etc/passwd
sudo egrep "^bin|^root|^dan|^tty|^wheel|^sshd|^audio|^cdrom|^dialout|^disk|^input|^kmem|^kvm|^lp|^render|^tape|^video|^dbus|^nobody|^mail|^slocate|^utmp" /etc/group | \
		sed -e "s/^slocate/mlocate/" | tee configs/etc/group
sudo egrep "^root|^dan|^sshd" /etc/shadow | sudo tee configs/etc/shadow
sudo cp -p configs/etc/{passwd,group,shadow} ${INSTALL_ROOT}/etc
sudo chmod 644 ${INSTALL_ROOT}/etc/{passwd,group}
sudo chmod 000 ${INSTALL_ROOT}/etc/shadow

sudo cp configs/etc/services ${INSTALL_ROOT}/etc
sudo cp configs/etc/hosts ${INSTALL_ROOT}/etc
sudo cp configs/etc/nsswitch.conf ${INSTALL_ROOT}/etc
sudo mkdir -p ${INSTALL_ROOT}/mnt/install
sudo mkdir -p ${INSTALL_ROOT}/mnt/sr0
sudo mkdir -p ${INSTALL_ROOT}/proc
sudo mkdir -p ${INSTALL_ROOT}/sys
sudo mkdir -p ${INSTALL_ROOT}/run
sudo mkdir -p ${INSTALL_ROOT}/packages/
sudo mkdir -p ${INSTALL_ROOT}/var/spool/pkg
sudo mkdir -p ${INSTALL_ROOT}/var/spool/mail
sudo mkdir -p ${INSTALL_ROOT}/tmp
sudo chmod 1777 ${INSTALL_ROOT}/tmp
sudo mkdir -p ${INSTALL_ROOT}/var/tmp
sudo chmod 1777 ${INSTALL_ROOT}/var/tmp
sudo touch ${INSTALL_ROOT}/etc/mtab
sudo mkdir -p ${INSTALL_ROOT}/dev
sudo mkdir -p ${INSTALL_ROOT}/dev/shm
sudo rm -f ${INSTALL_ROOT}/dev/null
sudo mknod ${INSTALL_ROOT}/dev/null c 1 3
sudo chmod 666 ${INSTALL_ROOT}/dev/null
sudo mkdir -p ${INSTALL_ROOT}/sbin
sudo cp ${INSTALL_ROOT}/usr/5bin/sh ${INSTALL_ROOT}/sbin/sh
sudo mkdir -p ${INSTALL_ROOT}/etc
sudo cp mtab ${INSTALL_ROOT}/etc/mtab
sudo mkdir -p ${INSTALL_ROOT}/usr/bin
# sudo cp ${INSTALL_ROOT}/bin/bash ${INSTALL_ROOT}/usr/bin/bash
sudo cp autopkg.sh ${INSTALL_ROOT}/autopkg.sh
sudo cp bootstrap.sh ${INSTALL_ROOT}/bootstrap.sh
sudo cp install-sda.sh ${INSTALL_ROOT}/root/install-sda.sh
# rungetty script no longer needed - deprecated
#sudo cp rungetty.sh ${INSTALL_ROOT}/
sudo mkdir -p ${INSTALL_ROOT}/etc/pam.d
sudo cp configs/etc/pam.d/system-auth ${INSTALL_ROOT}/etc/pam.d/system-auth
sudo cp configs/etc/pam.d/other ${INSTALL_ROOT}/etc/pam.d/other
sudo cp configs/etc/pam.d/login ${INSTALL_ROOT}/etc/pam.d/
sudo egrep "^root|^dan" /etc/shadow | sudo tee ${INSTALL_ROOT}/etc/shadow
sudo chmod 000 ${INSTALL_ROOT}/etc/shadow
ls -l ${INSTALL_ROOT}/etc/shadow
sudo cp configs/etc/ld.so.conf ${INSTALL_ROOT}/etc/ld.so.conf
sudo chmod 777 ${INSTALL_ROOT}

( cd ${INSTALL_ROOT}/var && sudo ln -sf spool/mail mail )

# HACK: install google fonts


sudo mkdir -p ${INSTALL_ROOT}/usr/share/fonts
sudo cp fonts/GoogleSans-Regular.ttf ${INSTALL_ROOT}/usr/share/fonts
sudo cp fonts/ttf/*.ttf ${INSTALL_ROOT}/usr/share/fonts
sudo mkdir -p ${INSTALL_ROOT}/home/dan
sudo cp configs/home/dan/Xdefaults ${INSTALL_ROOT}/home/dan/.Xdefaults
sudo cp configs/home/dan/Xdefaults ${INSTALL_ROOT}/home/dan/.Xresources
sudo mkdir -p ${INSTALL_ROOT}/home/dan/.config/sakura
sudo cp configs/home/dan/sakura.conf ${INSTALL_ROOT}/home/dan/.config/sakura/sakura.conf




sudo chown -R dan:dan ${INSTALL_ROOT}/home/dan
sudo mkdir -p ${INSTALL_ROOT}/usr/share/backgrounds/xfce
sudo cp graphics/syslinux.png ${INSTALL_ROOT}/usr/share/backgrounds/xfce/headrat-linux.png 

# date/timestamp + git short hash


GIT_CHANGES=`git status --porcelain=v1 2>/dev/null | wc -l`
if [ ${GIT_CHANGES} -gt 0 ]; then
	GIT_SUMMARY=" (+${GIT_CHANGES} local changes)"
	else
	GIT_SUMMARY=" (trunk)"
	fi

cp configs/etc/issue configs/etc/issue.tmp
echo "" >> configs/etc/issue.tmp
echo "Build "`date +"%Y%m%d:%H%M%S"`"#"`git rev-parse --short HEAD`"${GIT_SUMMARY}" >> configs/etc/issue.tmp
echo "" >> configs/etc/issue.tmp
sudo mv configs/etc/issue.tmp ${INSTALL_ROOT}/etc/issue

sudo cp configs/etc/inittab ${INSTALL_ROOT}/etc/inittab
sudo mkdir -p ${INSTALL_ROOT}/etc/init.d
sudo cp configs/etc/init.d/rc ${INSTALL_ROOT}/etc/init.d/rc
sudo cp configs/etc/init.d/rcS ${INSTALL_ROOT}/etc/init.d/rcS
sudo mkdir -p ${INSTALL_ROOT}/run
#sudo cp network.sh ${INSTALL_ROOT}/root/network.sh
sudo cp configs/etc/resolv.conf ${INSTALL_ROOT}/etc/resolv.conf
#sudo cp configs/etc/fstab ${INSTALL_ROOT}/etc/fstab
sudo mkdir -p ${INSTALL_ROOT}/boot
sudo cp -p kernel/bzImage ${INSTALL_ROOT}/boot/bzImage

# create devices

for i in `seq 0 9`; do 
	sudo rm -f ${INSTALL_ROOT}/dev/tty${i}
	sudo mknod ${INSTALL_ROOT}/dev/tty${i} c 4 ${i}
	sudo chown root:tty ${INSTALL_ROOT}/dev/tty${i}
	done

for i in `seq 0 5`; do
	sudo mkdir -p ${INSTALL_ROOT}/etc/rc${i}.d
	done

# creat homedir for dan

sudo mkdir -p ${INSTALL_ROOT}/home/dan
sudo chown dan:dan ${INSTALL_ROOT}/home/dan

