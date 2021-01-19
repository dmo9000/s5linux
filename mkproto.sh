#!/bin/sh
set -e
WORKING_DIR=`pwd`
PATH=$PATH:/usr/ccs/bin:/usr/5bin
echo "mkproto.sh: working directory is ${WORKING_DIR}"
ls -l 
rm -f prototype file.list

find .  ! -name "postinstall" \
	! -name "preremove"   \
	! -name "pkginfo"     \
	! -name "prototype"   \
	! -name "file.list"   \
	> file.list

md5sum file.list
rm -f prototype

echo "i pkginfo" > prototype 
# check if postinstall exists and if so, add it to prototype

if [ -e postinstall ]; then 
	echo "+++ postinstall script found; adding to prototype"
	echo "i postinstall" >> prototype
	else 
	echo "+++ No postinstall script found; skipping"
	fi

if [ -e preremove ]; then
        echo "+++ preremove script found; adding to prototype"
        echo "i preremove" >> prototype
        else
        echo "+++ No preremove script found; skipping"
        fi


( pkgproto < file.list) | sed -e "s/dan dan$/root root/g" \
		| sed -e "s/mockbuild mockbuild$/root root/g" \
		>> prototype && rm -f file.list

md5sum prototype
