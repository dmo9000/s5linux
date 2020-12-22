#!/bin/bash

echo "*** Creating /dev/sda1 ..."

echo ';' | /sbin/sfdisk /dev/sda 1>/dev/null 2>&1

echo "*** Formatting /dev/sda1 (ext4) ..."

/sbin/mkfs.ext4 /dev/sda1 1>/dev/null 2>&1

echo "*** Mounting new filesystem ..."

mount /dev/sda1 /mnt/sda1 1>/dev/null 2>&1

echo "*** Copying base system from /dev/sr0 to /dev/sda1 ..."

cp -ax / /mnt/sda1 1>/dev/null 2>&1

echo "*** Doing some minor housekeeping ... "

rm -rf /mnt/sda1/rr_moved
rm -rf /mnt/sda1/mnt/sda1
rm -f /mnt/sda1/install-sda1.sh

sync

echo "*** Unmounting /dev/sda1 ..."

umount /mnt/sda1 1>/dev/null 2>&1

echo "*** done."

