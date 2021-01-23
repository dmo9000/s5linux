#!/bin/sh
set -e
WORKING_DIR=`pwd`
PATH=$PATH:/usr/ccs/bin:/usr/5bin
echo "mkproto.sh: working directory is ${WORKING_DIR}"
ls -l 
sudo rm -f prototype file.list

sudo find .  ! -name "preinstall" \
	! -name "postinstall" \
	! -name "preremove"   \
	! -name "postremove"   \
	! -name "pkginfo"     \
	! -name "prototype"   \
	! -name "file.list"   \
	| sudo tee file.list

md5sum file.list
rm -f prototype

echo "i pkginfo" | sudo tee prototype 

sudo chmod 777 prototype

# check if pre/post install/remove exists and if so, add it to prototype

if [ -e preinstall ]; then
        echo "+++ preinstall script found; adding to prototype"
        echo "i preinstall" >> prototype
        else
        echo "+++ No preinstall script found; skipping"
        fi


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

if [ -e postremove ]; then
        echo "+++ postremove script found; adding to prototype"
        echo "i postremove" >> prototype
        else
        echo "+++ No postremove script found; skipping"
        fi



( pkgproto < file.list) | sed -e "s/dan dan$/root root/g" \
		| sed -e "s/mockbuild mockbuild$/root root/g" \
		>> prototype && sudo rm -f file.list

md5sum prototype
