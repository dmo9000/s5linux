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


#sudo brctl addbr br0
#sudo brctl addif br0 enp0s3 
#sudo tunctl -t tap0 -u `whoami`
#sudo brctl addif br0 tap0
#sudo ifconfig tap0 up
#sudo ifconfig br0 up
#sudo brctl show
#sudo dhclient -v br0

sudo qemu-system-x86_64 -m 4G -drive file=qemu-disks/sda.img,format=raw -cdrom images/bootable.iso -m 512 -boot ${1} #-netdev tap,id=mynet0,ifname=tap0,script=no,downscript=no -device e1000,netdev=mynet0 



