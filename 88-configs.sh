#!/bin/sh
set -e

sudo mkdir -p install-root/root
sudo mkdir -p install-root/var/sadm/install
sudo touch install-root/var/sadm/install/contents
# sudo cp configs/bashrc install-root/root/.bashrc
# sudo cp configs/bashrc install-root/root/.profile
# sudo cp configs/bashrc install-root/root/.bash_profile
sudo cp configs/bashrc install-root/etc/profile
sudo egrep "^root|^dan" /etc/passwd | tee configs/etc/passwd
sudo egrep "^root|^dan|^tty|^wheel" /etc/group | tee configs/etc/group
sudo cp configs/etc/{passwd,group} install-root/etc
sudo cp configs/etc/nsswitch.conf install-root/etc

sudo mkdir -p install-root/mnt/sda1
sudo mkdir -p install-root/proc
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
sudo cp configs/root-startup.sh install-root/root/startup.sh
sudo cp install-sda1.sh install-root/root/install-sda1.sh
sudo cp rungetty.sh install-root/
sudo mkdir -p install-root/etc/pam.d
sudo cp configs/etc/pam.d/login install-root/etc/pam.d/
sudo egrep "^root|^dan" /etc/shadow | sudo tee install-root/etc/shadow
sudo chmod 000 install-root/etc/shadow
ls -l install-root/etc/shadow
sudo cp configs/etc/ld.so.conf install-root/etc/ld.so.conf
sudo cp configs/etc/issue install-root/etc/issue

# create devices

for i in `seq 0 9`; do 
	sudo rm -f install-root/dev/tty${i}
	sudo mknod install-root/dev/tty${i} c 4 ${i}
	sudo chown root:tty install-root/dev/tty${i}
	done

# creat homedir for dan

sudo mkdir -p install-root/home/dan
sudo chown dan:dan install-root/home/dan
