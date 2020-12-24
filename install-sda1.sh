#!/bin/bash
/bin/dmesg -n 1

echo "*** Read to install to /dev/sda1 - hit ENTER to start"
read ENTER

echo "*** Creating /dev/sda1 ..."

echo ';' | /sbin/sfdisk /dev/sda 1>/dev/null 2>&1 

echo "*** Copying base install image ... "

/bin/dd if=/root/rootfs.ext4 of=/dev/sda1 bs=100M 1>/dev/null 2>&1

echo "*** Checking filesystem integrity ..."

/sbin/e2fsck -f /dev/sda1 1>/dev/null 2>&1

echo "*** Expanding filesystem on /dev/sda1 ..."

#echo "*** Formatting /dev/sda1 (ext4) ..."
#/sbin/mkfs.ext4 /dev/sda1 
echo "*** Mounting new filesystem ..."
mount /dev/sda1 /mnt/sda1 1>/dev/null 2>&1

echo "*** Expanding filesystem on /dev/sda1 ..."
/sbin/resize2fs /dev/sda1 1>/dev/null 2>&1
#echo "*** Copying base system from /dev/sr0 to /dev/sda1 ..."
#cp -pax / /mnt/sda1 

#echo "*** Copying package archive from installer DVD ..."
#cp -vpax /packages/* /mnt/sda1/packages/

echo "*** Doing some minor housekeeping ... "

rm -rf /mnt/sda1/rr_moved 
rm -rf /mnt/sda1/mnt/sda1
rm -rf /mnt/sda1/root/install-sda1.sh

sync

# echo "*** Installing SysV init ..."
# ( echo 1 && /usr/5bin/yes) | /bin/chroot /mnt/sda1 /usr/5bin/pkgadd -d /packages/S5LXsysvinit.pkg

echo "*** Unmounting /dev/sda1 ..."

umount /mnt/sda1 1>/dev/null 2>&1

echo "*** done."

echo "*** Hit ENTER to reboot the system"
read ENTER
/sbin/reboot -f
