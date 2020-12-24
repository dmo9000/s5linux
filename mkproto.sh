#!/bin/sh
WORKING_DIR=`pwd`
echo "mkproto.sh: working directory is ${WORKING_DIR}"
ls -l 
rm -f prototype file.list
find . ! -name "postinstall" ! -name "pkginfo" ! -name "prototype" ! -name "file.list" > file.list
md5sum file.list
rm -f prototype

echo "i pkginfo" > prototype 
# check if postinstall exists and if so, add it to prototype
if [ ! -x "postinstall " ]; then 
	echo "+++ postinstall script found; adding to prototype"
	echo "i postinstall" >> prototype
	else 
	echo "+++ No postinstall script found; skipping"
	fi

( /usr/ccs/bin/pkgproto < file.list) | sed -e "s/dan dan$/root root/g" \
		>> prototype && rm -f file.list

md5sum prototype
