#!/bin/sh

sudo rm -rf images/ISO-ROOT
mkdir -p images/ISO-ROOT/isolinux
cp /usr/share/syslinux/isolinux.bin images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/menu.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/libutil.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/ldlinux.c32 images/ISO-ROOT/isolinux/ 


# copy kernel

mkdir -p images/ISO-ROOT/images
cp kernel/bzImage images/ISO-ROOT/images

sudo chmod -R 755 images/ISO-ROOT/

cat <<EOF > images/ISO-ROOT/isolinux/isolinux.cfg
UI menu.c32

MENU TITLE HEADRAT LINUX

LABEL HeadRatLinux 
    MENU LABEL ^HeadRat Linux Live
    MENU DEFAULT
    KERNEL /images/bzImage
    APPEND root=/dev/sr0 init=/root/startup.sh
    TEXT HELP
       	Boot HeadRat Linux live image 
    ENDTEXT

EOF

find images/ISO-ROOT/ -type f
sudo cp -rfp install-root/* images/ISO-ROOT/ 

sudo genisoimage -rational-rock -volid "HeadRat Linux" -cache-inodes \
	-joliet -full-iso9660-filenames -input-charset UTF8 \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-output images/bootable.iso images/ISO-ROOT/

cat images/ISO-ROOT/isolinux/isolinux.cfg
