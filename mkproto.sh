#!/bin/sh

rm -f prototype file.list
find . ! -name "pkginfo" ! -name "prototype" ! -name "file.list" > file.list
md5sum file.list
#(echo "i pkginfo" && stdbuf -o0 /usr/ccs/bin/pkgproto < file.list) | sed -e "s/dan dan$/root root/g" > prototype && rm -f file.list
(echo "i pkginfo" && stdbuf -o0 ../../utils/pkgproto < file.list) | sed -e "s/dan dan$/root root/g" > prototype && rm -f file.list

md5sum prototype
