#!/bin/sh
#qemu-system-x86_64 -kernel kernel/bzImage 

# boot kernel direct, mount rootfs ISO on root filesystem
#qemu-system-x86_64 -kernel kernel/bzImage -cdrom images/rootfs.iso -m 512	\
#       -append "root=/dev/sr0 init=/bin/bash"

# boot kernel direct, mount rootfs ISO on root filesystem
#qemu-system-x86_64 -kernel kernel/bzImage -cdrom images/bootable.iso -m 512	\
#       -append "root=/dev/sr0 init=/bin/bash"

# boot kernel from DVD, mount rootfs ISO on root filesystem
if [ ! -r qemu-disks/sda.img ]; then 
	echo "*** Creating 16GB disk image ..."
	qemu-img create -f raw qemu-disks/sda.img 16G
	else
	echo "disk image already exists: qemu-disks/sda.img"
	fi
#qemu-system-x86_64 -cdrom images/bootable.iso -m 512 -boot d
#qemu-system-x86_64 qemu-disks/sda.img -cdrom images/bootable.iso -m 512 -boot d
qemu-system-x86_64 -drive file=qemu-disks/sda.img,format=raw -cdrom images/bootable.iso -m 512 -boot ${1} 



