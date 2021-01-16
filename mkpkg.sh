#!/bin/sh

if [ ! -r pkginfo ]; then 
	echo "pkginfo file is not readable; exiting"
	exit 1
	fi

PKGNAME=`grep "PKG=" pkginfo | sed -e "s/^.*=//g"`
rm -rf ../../spool/${PKGNAME}
pkgmk -o -r `pwd` -d ../../spool
cat pkginfo
cd ../../spool
../mkstream.sh ${PKGNAME}
