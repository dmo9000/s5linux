#!/bin/sh

sudo rm -rf images/ISO-ROOT
mkdir -p images/ISO-ROOT/isolinux
cp /usr/share/syslinux/isolinux.bin images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/menu.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/libutil.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/ldlinux.c32 images/ISO-ROOT/isolinux/ 
cp /usr/share/syslinux/libcom32.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/vesamenu.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/chain.c32 images/ISO-ROOT/isolinux/

cp graphics/syslinux.png images/ISO-ROOT/isolinux/syslinux.png
#cp graphics/sun8x16.psfu images/ISO-ROOT/isolinux/sun8x16.psfu

mkdir -p images/ISO-ROOT/etc
rm -f images/ISO-ROOT/etc/fstab
echo "/dev/sr0 / iso9660 defaults 0 0" >> images/ISO-ROOT/etc/fstab
echo "proc           /proc        proc   defaults        0     0" >> images/ISO-ROOT/etc/fstab
echo "sysfs          /sys         sysfs  defaults        0     0" >> images/ISO-ROOT/etc/fstab 
echo "devpts         /dev/pts     devpts gid=4,mode=620  0     0" >> images/ISO-ROOT/etc/fstab 
echo "tmpfs          /dev/shm     tmpfs  defaults        0     0" >> images/ISO-ROOT/etc/fstab 
echo "tmpfs          /run     tmpfs  defaults        0     0" >> images/ISO-ROOT/etc/fstab 

# copy kernel

mkdir -p images/ISO-ROOT/images
cp kernel/bzImage images/ISO-ROOT/images

sudo chmod -R 755 images/ISO-ROOT/

cat <<EOF > images/ISO-ROOT/isolinux/isolinux.cfg
DEFAULT vesamenu.c32
timeout 600
menu background syslinux.png
font sun8x16.psfu

MENU TITLE HEADRAT LINUX

LABEL HeadRatLinuxLive 
    MENU LABEL ^HeadRat Linux Live
    MENU DEFAULT
    KERNEL /images/bzImage
    APPEND root=/dev/sr0 ro init=/sbin/init fbcon=font:SUN8x16 quiet splash biosdevname=0 net.ifnames=0 1
    TEXT HELP
       	Boot HeadRat Linux live image 
    ENDTEXT

LABEL HeadRatLinuxInstaller
    MENU LABEL ^HeadRat Linux Install to /dev/sda2 
    KERNEL /images/bzImage
    APPEND root=/dev/sr0 ro init=/root/install-sda.sh fbcon=font:SUN8x16 quiet splash biosdevname=0 net.ifnames=0
    TEXT HELP
	Install HeadRat Linux to (/dev/sda2) 
    ENDTEXT

LABEL HeadRatLinuxViaInit
    MENU LABEL ^HeadRat Linux via SysVInit (/dev/sda2) 
    KERNEL /images/bzImage
    APPEND root=/dev/sda2 rw init=/sbin/init fbcon=font:SUN8x16 quiet splash biosdevname=0 net.ifnames=0
    TEXT HELP
        Boot HeadRat Linux via SysVInit (/dev/sda2) 
    ENDTEXT

LABEL HeadRatLinuxInstalledSystem
    MENU LABEL ^HeadRat Linux Installed System (/dev/sda2) 
    COM32 /isolinux/chain.c32
    APPEND hd0
    TEXT HELP
        Boot HeadRat Linux InstalledSystem (/dev/sda2) 
    ENDTEXT


EOF

find images/ISO-ROOT/ -type f
sudo cp -rfp install-root/* images/ISO-ROOT/ 

# remove the installation packages from the rootfs which will be deployed

sudo rm -f install-root/packages/*.pkg

# build and copy the ext4 image as well
./buildrootfs.sh

#sudo cp -p images/rootfs.ext4 images/ISO-ROOT/root/rootfs.ext4
sudo cp -p images/rootfs.ext4.gz images/ISO-ROOT/root/rootfs.ext4.gz

sudo genisoimage -rational-rock -volid "HeadRat Linux" -cache-inodes \
	-joliet -full-iso9660-filenames -input-charset UTF8 \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-output images/bootable.iso images/ISO-ROOT/

cat images/ISO-ROOT/isolinux/isolinux.cfg
sudo find kernel -name "bzImage" -exec md5sum {} \;
sudo find images -name "bzImage" -exec md5sum {} \;
