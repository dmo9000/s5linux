#!/bin/bash

echo "*** Creating /dev/sda1 ..."

echo ';' | /sbin/sfdisk /dev/sda 

echo "*** Copying base install image ... "

/bin/dd if=/root/rootfs.ext4 of=/dev/sda1 bs=100M

echo "*** Checking filesystem integrity ..."

/sbin/e2fsck -f /dev/sda1

echo "*** Expanding filesystem on /dev/sda1 ..."

/sbin/resize2fs /dev/sda1

#echo "*** Formatting /dev/sda1 (ext4) ..."
#/sbin/mkfs.ext4 /dev/sda1 
echo "*** Mounting new filesystem ..."
mount /dev/sda1 /mnt/sda1 
#echo "*** Copying base system from /dev/sr0 to /dev/sda1 ..."
#cp -pax / /mnt/sda1 

echo "*** Doing some minor housekeeping ... "

rm -rf /mnt/sda1/rr_moved
rm -rf /mnt/sda1/mnt/sda1
rm -rf /mnt/sda1/root/install-sda1.sh

sync

echo "*** Unmounting /dev/sda1 ..."

umount /mnt/sda1 

echo "*** done."

