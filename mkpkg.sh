#!/bin/sh
set -e
PATH=$PATH:/usr/ccs/bin:/usr/5bin

if [ ! -r pkginfo ]; then 
	echo "pkginfo file is not readable; exiting"
	exit 1
	fi

PKGNAME=`grep "PKG=" pkginfo | sed -e "s/^.*=//g"`
#rm -rf ../../spool/${PKGNAME}
#pkgmk -o -r `pwd` -d ../../spool

HAS_VERSION=`grep ^VERSION= pkginfo | wc -l`
if [ ${HAS_VERSION} -eq 0 ]; then 
		echo ""
		echo "*** pkginfo file is missing VERSION field"
		echo ""
		exit 1
	else 
	VERSION=`grep ^VERSION= pkginfo | sed -e "s/^.*=\(.*\)$/\1/g"`
	if [ "${VERSION}" == "000000" ]; then
		echo ""
		echo "*** VERSION field in pkginfo is invalid: ${VERSION}"
		echo ""
		exit 1
	fi
fi

HAS_PSTAMP=`grep "^PSTAMP=" pkginfo | wc -l`
if [ ${HAS_PSTAMP} -eq 0 ]; then 
	echo ""
	echo "*** pkginfo file is missing PSTAMP field, adding automatically now..."
	echo ""
	PSTAMP=`date +"%Y%m%d%H%M%S"`
	echo "PSTAMP=${PSTAMP}" >> pkginfo
	fi

cat pkginfo

rm -rf ../../spool/${PKGNAME}
pkgmk -o -r `pwd` -d ../../spool
cd ../../spool
../mkstream.sh ${PKGNAME}
