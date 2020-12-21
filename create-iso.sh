#!/bin/sh

mkdir -p images/ISO-ROOT/isolinux
cp /usr/share/syslinux/isolinux.bin images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/menu.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/libutil.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/ldlinux.c32 images/ISO-ROOT/isolinux/ 


# copy kernel

mkdir -p images/ISO-ROOT/images
sudo cp /boot/vmlinuz-5.9.14-200.fc33.x86_64 images/ISO-ROOT/images/
sudo cp /boot/initramfs-5.9.14-200.fc33.x86_64.img images/ISO-ROOT/images/
sudo cp images/rootfs.ext4 images/ISO-ROOT/images/
sudo mkdir -p images/ISO-ROOT/LiveOS
sudo cp images/rootfs.ext4 images/ISO-ROOT/LiveOS/squashfs.img

sudo chmod -R 755 images/ISO-ROOT/

cat <<EOF > images/ISO-ROOT/isolinux/isolinux.cfg
UI menu.c32

MENU TITLE HEADRAT LINUX

LABEL HeadRatLinux 
    MENU LABEL ^HeadRat Linux Live
    MENU DEFAULT
    KERNEL /images/vmlinuz-5.9.14-200.fc33.x86_64
    INITRD /images/initramfs-5.9.14-200.fc33.x86_64.img
    APPEND root=/images/rootfs.ext4 vga=355 1 
    TEXT HELP
       	Boot HeadRat Linux live image 
    ENDTEXT

#LABEL TEST
#	MENU LABEL Back to boot proccess
#	MENU DEFAULT
#	LOCALBOOT 0
#	TEXT HELP
#		Exit and continue normal boot
#	ENDTEXT

EOF

find images/ISO-ROOT/ -type f

genisoimage -rational-rock -volid "HeadRat Linux" -cache-inodes \
	-joliet -full-iso9660-filenames -input-charset UTF8 \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-output images/bootable.iso images/ISO-ROOT/

cat images/ISO-ROOT/isolinux/isolinux.cfg
