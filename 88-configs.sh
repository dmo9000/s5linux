#!/bin/sh
set -e

sudo mkdir -p install-root/root
sudo mkdir -p install-root/var/sadm/install
sudo touch install-root/var/sadm/install/contents
sudo mkdir -p install-root/libx32
sudo mkdir -p install-root/usr/libx32



# sudo cp configs/bashrc install-root/root/.bashrc
# sudo cp configs/bashrc install-root/root/.profile
# sudo cp configs/bashrc install-root/root/.bash_profile

# FIXME: do something better here
#        especially the sshd user setup should be moved to the S5LXopenssh postinstall script

sudo cp configs/profile install-root/etc/profile
sudo egrep "^bin|^root|^dan|^sshd|^dbus" /etc/passwd | tee configs/etc/passwd
sudo egrep "^bin|^root|^dan|^tty|^wheel|^sshd|^audio|^cdrom|^dialout|^disk|^input|^kmem|^kvm|^lp|^render|^tape|^video|^dbus" /etc/group | tee configs/etc/group
sudo egrep "^root|^dan|^sshd" /etc/shadow | sudo tee configs/etc/shadow
sudo cp -p configs/etc/{passwd,group,shadow} install-root/etc
sudo chmod 644 install-root/etc/{passwd,group}
sudo chmod 000 install-root/etc/shadow

sudo cp configs/etc/services install-root/etc
sudo cp configs/etc/hosts install-root/etc
sudo cp configs/etc/nsswitch.conf install-root/etc
sudo mkdir -p install-root/mnt/install
sudo mkdir -p install-root/mnt/sr0
sudo mkdir -p install-root/proc
sudo mkdir -p install-root/sys
sudo mkdir -p install-root/run
sudo mkdir -p install-root/packages/
sudo mkdir -p install-root/var/spool/pkg
sudo mkdir -p install-root/tmp
sudo chmod 1777 install-root/tmp
sudo mkdir -p install-root/var/tmp
sudo chmod 1777 install-root/var/tmp
sudo touch install-root/etc/mtab
sudo mkdir -p install-root/dev
sudo mkdir -p install-root/dev/shm
sudo rm -f install-root/dev/null
sudo mknod install-root/dev/null c 1 3
sudo chmod 666 install-root/dev/null
sudo mkdir -p install-root/sbin
sudo cp install-root/usr/5bin/sh install-root/sbin/sh
sudo mkdir -p install-root/etc
sudo cp mtab install-root/etc/mtab
sudo mkdir -p install-root/usr/bin
# sudo cp install-root/bin/bash install-root/usr/bin/bash
sudo cp bootstrap.sh install-root/bootstrap.sh
sudo cp install-sda.sh install-root/root/install-sda.sh
# rungetty script no longer needed - deprecated
#sudo cp rungetty.sh install-root/
sudo mkdir -p install-root/etc/pam.d
sudo cp configs/etc/pam.d/login install-root/etc/pam.d/
sudo egrep "^root|^dan" /etc/shadow | sudo tee install-root/etc/shadow
sudo chmod 000 install-root/etc/shadow
ls -l install-root/etc/shadow
sudo cp configs/etc/ld.so.conf install-root/etc/ld.so.conf
sudo chmod 777 install-root

# HACK: install google fonts


sudo mkdir -p install-root/usr/share/fonts
sudo cp fonts/GoogleSans-Regular.ttf install-root/usr/share/fonts
sudo mkdir -p install-root/home/dan
echo "xfce4-session" | sudo tee install-root/home/dan/.xinitrc
sudo chown -R dan:dan install-root/home/dan
sudo mkdir -p install-root/usr/share/backgrounds/xfce
sudo cp graphics/syslinux.png install-root/usr/share/backgrounds/xfce/headrat-linux.png 

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
sudo mv configs/etc/issue.tmp install-root/etc/issue

sudo cp configs/etc/inittab install-root/etc/inittab
sudo mkdir -p install-root/etc/init.d
sudo cp configs/etc/init.d/rc install-root/etc/init.d/rc
sudo cp configs/etc/init.d/rcS install-root/etc/init.d/rcS
sudo mkdir -p install-root/run
sudo cp network.sh install-root/root/network.sh
sudo cp configs/etc/resolv.conf install-root/etc/resolv.conf
#sudo cp configs/etc/fstab install-root/etc/fstab
sudo mkdir -p install-root/boot
sudo cp -p kernel/bzImage install-root/boot/bzImage

# create devices

for i in `seq 0 9`; do 
	sudo rm -f install-root/dev/tty${i}
	sudo mknod install-root/dev/tty${i} c 4 ${i}
	sudo chown root:tty install-root/dev/tty${i}
	done

for i in `seq 0 5`; do
	sudo mkdir -p install-root/etc/rc${i}.d
	done

# creat homedir for dan

sudo mkdir -p install-root/home/dan
sudo chown dan:dan install-root/home/dan

