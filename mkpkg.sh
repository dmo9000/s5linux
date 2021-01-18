#!/bin/sh

if [ ! -r pkginfo ]; then 
	echo "pkginfo file is not readable; exiting"
	exit 1
	fi

PKGNAME=`grep "PKG=" pkginfo | sed -e "s/^.*=//g"`
rm -rf ../../spool/${PKGNAME}
pkgmk -o -r `pwd` -d ../../spool

HAS_PSTAMP=`grep ^PSTAMP pkginfo | wc -l`
if [ ${HAS_PSTAMP} -eq 0 ]; then 
	echo ""
	echo "*** pkginfo file is missing PSTAMP field"
	echo ""
	exit 1
	fi

cat pkginfo
cd ../../spool
../mkstream.sh ${PKGNAME}
