#!/bin/sh

# get the size of the root filesystem image, and increase it by 50%

ROOTSIZE=`du -s install-root | awk '{ print $1 }'`
PADDEDSIZE=`echo "$ROOTSIZE * 1.5" | bc | sed -e "s/\..*//g"`

echo "root size   = ${ROOTSIZE}"
echo "padded size = ${PADDEDSIZE}"

# create the empty raw image

#dd if=/dev/zero of=images/rootfs.ext4 bs=1k count=${PADDEDSIZE}

# format as ext4

# mkfs -t ext4 -F -m 0 images/rootfs.ext4 
#mkfs -t squashfs images/rootfs.ext4
sudo rm -f images/squashfs.img
sudo mksquashfs ./install-root ./images/squashfs.img -b 1048576 -comp xz -Xdict-size 100%

# create mount point

#mkdir -p images/rootfs.mounted
#sudo mount -o loop images/rootfs.ext4 images/rootfs.mounted
#sudo cp -rfpv install-root/* images/rootfs.mounted/
#sudo umount images/rootfs.mounted
