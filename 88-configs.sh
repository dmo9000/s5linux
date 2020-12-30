#!/bin/sh
set -e

sudo mkdir -p install-root/root
sudo mkdir -p install-root/var/sadm/install
sudo touch install-root/var/sadm/install/contents
# sudo cp configs/bashrc install-root/root/.bashrc
# sudo cp configs/bashrc install-root/root/.profile
# sudo cp configs/bashrc install-root/root/.bash_profile

# FIXME: do something better here
#        especially the sshd user setup should be moved to the S5LXopenssh postinstall script

sudo cp configs/profile install-root/etc/profile
sudo egrep "^root|^dan|^sshd" /etc/passwd | tee configs/etc/passwd
sudo egrep "^root|^dan|^tty|^wheel|^sshd" /etc/group | tee configs/etc/group
sudo egrep "^root|^dan|^sshd" /etc/shadow | sudo tee configs/etc/shadow
sudo cp -p configs/etc/{passwd,group,shadow} install-root/etc
sudo chmod 644 install-root/etc/{passwd,group}
sudo chmod 000 install-root/etc/shadow

sudo cp configs/etc/nsswitch.conf install-root/etc
sudo mkdir -p install-root/mnt/install
sudo mkdir -p install-root/mnt/sr0
sudo mkdir -p install-root/proc
sudo mkdir -p install-root/sys
sudo mkdir -p install-root/run
sudo mkdir -p install-root/packages/
sudo mkdir -p install-root/var/spool/pkg
sudo mkdir -p install-root/tmp
sudo mkdir -p install-root/var/tmp
sudo touch install-root/etc/mtab
sudo mkdir -p install-root/dev
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
sudo cp rungetty.sh install-root/
sudo mkdir -p install-root/etc/pam.d
sudo cp configs/etc/pam.d/login install-root/etc/pam.d/
sudo egrep "^root|^dan" /etc/shadow | sudo tee install-root/etc/shadow
sudo chmod 000 install-root/etc/shadow
ls -l install-root/etc/shadow
sudo cp configs/etc/ld.so.conf install-root/etc/ld.so.conf
sudo cp configs/etc/issue install-root/etc/issue
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

