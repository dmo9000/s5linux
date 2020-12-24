#!/bin/bash
/bin/dmesg -n 1

echo "*** Read to install to /dev/sda2 - hit ENTER to start"
read ENTER

echo "** Wiping partition table on /dev/sda ..."
/sbin/wipefs --force -a /dev/sda

echo "*** Creating /boot and /root partitions ..."

#echo ';' | /sbin/sfdisk /dev/sda 1>/dev/null 2>&1 
printf "type=83,size=100M,bootable\ntype=83\n" | /sbin/sfdisk /dev/sda

echo "*** Formatting /boot (/dev/sda1) as ext4 ..."
/sbin/mkfs.ext4 /dev/sda1

echo "*** Copying base install image ... "

/bin/dd if=/root/rootfs.ext4 of=/dev/sda2 bs=100M 1>/dev/null 2>&1

echo "*** Checking filesystem integrity ..."

/sbin/e2fsck -f /dev/sda2 1>/dev/null 2>&1

echo "*** Expanding filesystem on /dev/sda2 ..."

echo "*** Mounting new filesystem ..."
mount /dev/sda2 /mnt/install 1>/dev/null 2>&1

echo "*** Expanding filesystem on /dev/sda2 ..."
/sbin/resize2fs /dev/sda2 1>/dev/null 2>&1

echo "*** Doing some minor housekeeping ... "

echo "/dev/sda1 /boot ext4 defaults 0 0" >> /mnt/install/etc/fstab
echo "/dev/sda2 / ext4 defaults 0 0" >> /mnt/install/etc/fstab

rm -rf /mnt/install/boot/bzImage
rm -rf /mnt/install/rr_moved 
rm -rf /mnt/install/mnt/install
rm -rf /mnt/install/root/install-sda.sh
sync
echo "*** Unmounting /dev/sda2 ..."
umount /mnt/install 1>/dev/null 2>&1

echo "*** Installing kernel (bzImage) to /boot ..."
mount /dev/sda1 /mnt/install 1>/dev/null 2>&1
cp -v /boot/bzImage /mnt/install/bzImage
sync
umount /mnt/install 1>/dev/null 2>&1
echo "*** done."

echo "*** Hit ENTER to reboot the system"
read ENTER
/sbin/reboot -f
