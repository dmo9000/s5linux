#!/bin/sh

mount proc /proc -t proc
mkdir -p /dev/pts
mount devpts /dev/pts -t devpts

/usr/5bin/hostname headrat.linux

echo "Welcome to HeadRat Linux"
echo ""
echo " * switch to /dev/tty2 to login"
echo ""

while [ 1 ] ; do 
	/sbin/agetty -s 38400 -t 600 tty2 linux
	done
