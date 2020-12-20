sudo mkdir -p install-root/root
sudo mkdir -p install-root/var/sadm/install
sudo touch install-root/var/sadm/install/contents
sudo cp configs/bashrc install-root/root/.bashrc
sudo cp configs/etc/{passwd,group} install-root/etc
sudo cp configs/etc/nsswitch.conf install-root/etc
sudo mkdir -p install-root/packages/
sudo mkdir -p install-root/var/spool/pkg
sudo mkdir -p install-root/tmp
sudo mkdir -p install-root/var/tmp
sudo touch install-root/etc/mtab
sudo mkdir -p install-root/dev
sudo mknod install-root/dev/null c 1 3
sudo chmod 666 install-root/dev/null
sudo mkdir -p install-root/sbin
sudo cp install-root/usr/5bin/sh install-root/sbin/sh
sudo mkdir -p install-root/etc
sudo cp mtab install-root/etc/mtab
sudo mkdir -p install-root/usr/bin
# sudo cp install-root/bin/bash install-root/usr/bin/bash
sudo cp bootstrap.sh install-root/bootstrap.sh
