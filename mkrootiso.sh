#!/bin/sh

genisoimage -rational-rock -volid "HeadRat Linux rootfs" -cache-inodes \
        -joliet -full-iso9660-filenames -input-charset UTF8 \
        -output images/rootfs.iso install-root/ 

