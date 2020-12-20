#!/bin/sh
PKGNAME=`grep "PKG=" pkginfo | sed -e "s/^.*=//g"`
rm -rf ../../spool/${PKGNAME}
pkgmk -o -r `pwd` -d ../../spool
cd ../../spool
../mkstream.sh ${PKGNAME}
