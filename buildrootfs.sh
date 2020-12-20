#!/bin/sh

# get the size of the root filesystem image, and increase it by 50%

ROOTSIZE=`du -s install-root | awk '{ print $1 }'`
PADDEDSIZE=`echo "$ROOTSIZE * 1.5" | bc | sed -e "s/\..*//g"`

echo "root size   = ${ROOTSIZE}"
echo "padded size = ${PADDEDSIZE}"

# create the empty raw image

dd if=/dev/zero of=images/rootfs.ext4 bs=1k count=${PADDEDSIZE}

# format as ext4

mkfs -t ext4 -F -m 0 images/rootfs.ext4 
