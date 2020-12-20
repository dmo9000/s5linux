#!/bin/sh

mkdir -p images/ISO-ROOT/isolinux
cp /usr/share/syslinux/isolinux.bin images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/menu.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/libutil.c32 images/ISO-ROOT/isolinux/
cp /usr/share/syslinux/ldlinux.c32 images/ISO-ROOT/isolinux/ 

cat <<EOF > images/ISO-ROOT/isolinux/isolinux.cfg
UI menu.c32

MENU TITLE "THIS IS A TEST"

LABEL TEST
	MENU LABEL Back to boot proccess
	MENU DEFAULT
	LOCALBOOT 0
	TEXT HELP
		Exit and continue normal boot
	ENDTEXT
EOF

genisoimage -rational-rock -volid "HeadRat Linux" -cache-inodes \
	-joliet -full-iso9660-filenames -input-charset UTF8 \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-output images/bootable.iso images/ISO-ROOT/
