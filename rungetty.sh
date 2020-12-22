#!/bin/sh

hostname headrat.linux

echo "Welcome to HeadRat Linux"
echo ""
echo " * switch to /dev/tty2 to login"
echo ""

/sbin/agetty -s 38400 -t 600 tty2 linux
