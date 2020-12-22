#!/bin/sh

sudo rm -rf images/ISO-ROOT
mkdir -p images/ISO-ROOT/isolinux
cp /usr/share/syslinux/isolinux.bin images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/menu.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/libutil.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/ldlinux.c32 images/ISO-ROOT/isolinux/ 
cp /usr/share/syslinux/libcom32.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/vesamenu.c32 images/ISO-ROOT/isolinux/
cp graphics/syslinux.png images/ISO-ROOT/isolinux/syslinux.png
cp graphics/sun12x22.psfu images/ISO-ROOT/isolinux/sun12x22.psfu


# copy kernel

mkdir -p images/ISO-ROOT/images
cp kernel/bzImage images/ISO-ROOT/images

sudo chmod -R 755 images/ISO-ROOT/

cat <<EOF > images/ISO-ROOT/isolinux/isolinux.cfg
DEFAULT vesamenu.c32
timeout 600
menu background syslinux.png
font sun12x22.psfu

MENU TITLE HEADRAT LINUX

LABEL HeadRatLinuxLive 
    MENU LABEL ^HeadRat Linux Live
    MENU DEFAULT
    KERNEL /images/bzImage
    APPEND root=/dev/sr0 ro init=/root/startup.sh fbcon=font:SUN8x16
    TEXT HELP
       	Boot HeadRat Linux live image 
    ENDTEXT

LABEL HeadRatLinuxInstalled
    MENU LABEL ^HeadRat Linux (/dev/sda1) 
    KERNEL /images/bzImage
    APPEND root=/dev/sda1 rw init=/root/startup.sh fbcon=font:SUN8x16
    TEXT HELP
	Boot HeadRat Linux (/dev/sda1) 
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
find . -name "bzImage" -exec md5sum {} \;