#!/bin/bash
/bin/dmesg -n 1

#echo "*** Read to install to /dev/sda2 - hit ENTER to start"
#read ENTER

/usr/bin/clear

cat /etc/issue

echo "*** Wiping partition table on /dev/sda ..."
/sbin/wipefs --force -a /dev/sda 1>/dev/null 2>&1

echo "  *** Creating /boot and /root partitions ..."

#echo ';' | /sbin/sfdisk /dev/sda 1>/dev/null 2>&1 
printf "type=83,size=100M,bootable\ntype=83\n" | /sbin/sfdisk /dev/sda 1>/dev/null 2>&1

echo "  *** Formatting /boot (/dev/sda1) as ext4 ..."
/sbin/wipefs --force -a /dev/sda1 1>/dev/null 2>&1
/sbin/mkfs.ext4 /dev/sda1 1>/dev/null 2>&1

echo "*** Copying base install image ... "
/sbin/wipefs --force -a /dev/sda2 1>/dev/null 2>&1
#/bin/dd if=/root/rootfs.ext4 of=/dev/sda2 bs=100M 1>/dev/null 2>&1 1>/dev/null 2>&1
#/usr/bin/pv /root/rootfs.ext4 > /dev/sda2 
zcat /root/rootfs.ext4.gz | /bin/dd of=/dev/sda2 bs=100M 1>/dev/null 2>&1 1>/dev/null 2>&1

echo "  *** Checking filesystem integrity ..."

/sbin/e2fsck -f /dev/sda2 1>/dev/null 2>&1
/sbin/resize2fs -f /dev/sda2 1>/dev/null 

#echo "  *** Expanding filesystem on /dev/sda2 ..."
echo "    *** Mounting new filesystem ..."
mount /dev/sda2 /mnt/install 1>/dev/null 2>&1
#echo "    *** Resizing new filesystem ..."
#/sbin/resize2fs -f /dev/sda2 

echo "*** Doing some minor housekeeping ... "

rm -rf /mnt/install/boot/bzImage
rm -rf /mnt/install/rr_moved 
rm -rf /mnt/install/mnt/install
rm -rf /mnt/install/root/install-sda.sh
sync

echo "*** Installing kernel (bzImage) to /boot ..."
mount /dev/sda1 /mnt/install/boot 1>/dev/null 2>&1
cp -v /boot/bzImage /mnt/install/boot/bzImage 1>/dev/null 2>&1
sync

mkdir -p /mnt/install/boot/grub
cat << __GRUB_CFG__ > /mnt/install/boot/grub/grub.cfg
menuentry "HeadRat Linux" {
        set root=(hd0,1)
        linux   /bzImage root=/dev/sda2 rw nomodeset quiet splash
}
__GRUB_CFG__

mount --rbind /dev /mnt/install/dev
mount --rbind /proc /mnt/install/proc
mount --rbind /sys /mnt/install/sys
mount --rbind /run /mnt/install/run
chroot /mnt/install /usr/sbin/grub-install /dev/sda 1>/dev/null 2>&1


rm -f /mnt/install/etc/fstab
echo "/dev/sda1 /boot ext4 defaults 0 0" >> /mnt/install/etc/fstab
echo "/dev/sda2 / ext4 defaults 0 0" >> /mnt/install/etc/fstab
echo "/dev/sr0 /mnt/sr0 iso9660 defaults 0 0" >> /mnt/install/etc/fstab
echo "proc           /proc        proc   defaults        0     0" >> /mnt/install/etc/fstab
echo "sysfs          /sys         sysfs  defaults        0     0" >> /mnt/install/etc/fstab
echo "devpts         /dev/pts     devpts gid=4,mode=620  0     0" >> /mnt/install/etc/fstab
echo "tmpfs          /dev/shm     tmpfs  defaults        0     0" >> /mnt/install/etc/fstab


echo -n "*** Unmounting /dev/sda1 ... "
umount /mnt/install/boot 1>/dev/null 2>&1
echo "done."

echo -n "*** Unmounting /dev/sda2 ... "
umount /mnt/install 1>/dev/null 2>&1
echo "done."

echo "*** Hit ENTER to reboot the system"
read ENTER
/sbin/reboot -f
