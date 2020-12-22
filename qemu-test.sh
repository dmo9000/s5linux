#!/bin/sh
#qemu-system-x86_64 -kernel kernel/bzImage 

# boot kernel direct, mount rootfs ISO on root filesystem
#qemu-system-x86_64 -kernel kernel/bzImage -cdrom images/rootfs.iso -m 512	\
#       -append "root=/dev/sr0 init=/bin/bash"

# boot kernel direct, mount rootfs ISO on root filesystem
#qemu-system-x86_64 -kernel kernel/bzImage -cdrom images/bootable.iso -m 512	\
#       -append "root=/dev/sr0 init=/bin/bash"

# boot kernel from DVD, mount rootfs ISO on root filesystem
echo "Creating 5GB disk image ..."
if [ ! -r qemu-disks/sda1.img ]; then 
	echo "Creating 5GB disk image ..."
	qemu-img create -f raw qemu-disks/sda1.img 5G
	else
	echo "disk image already exists: qemu-disks/sda1.img"
	fi
#qemu-system-x86_64 -cdrom images/bootable.iso -m 512 -boot d
#qemu-system-x86_64 qemu-disks/sda1.img -cdrom images/bootable.iso -m 512 -boot d
qemu-system-x86_64 -drive file=qemu-disks/sda1.img,format=raw -cdrom images/bootable.iso -m 512 -boot d



