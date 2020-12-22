#!/bin/sh
#qemu-system-x86_64 -kernel kernel/bzImage 

# boot kernel direct, mount rootfs ISO on root filesystem
#qemu-system-x86_64 -kernel kernel/bzImage -cdrom images/rootfs.iso -m 512	\
#       -append "root=/dev/sr0 init=/bin/bash"

# boot kernel direct, mount rootfs ISO on root filesystem
#qemu-system-x86_64 -kernel kernel/bzImage -cdrom images/bootable.iso -m 512	\
#       -append "root=/dev/sr0 init=/bin/bash"

# boot kernel from DVD, mount rootfs ISO on root filesystem
qemu-system-x86_64 -cdrom images/bootable.iso -m 512 -boot d

