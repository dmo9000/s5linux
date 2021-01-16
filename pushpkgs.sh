#!/bin/sh

PKGROOT=/devel/packages/s5linux

for PKG in `ls -1 spool/*.pkg.gz`; do 
	PKGDIR=`dirname ${PKG}`
	PKGFILE=`basename ${PKG}`

	if [ "${PKGDIR}/${PKGFILE}" -nt "${PKGROOT}/${PKGFILE}" ] || [ ! -r "${PKGROOT}/${PKGFILE}" ]; then
		echo "-> Pushing ${PKG} ..."
		sudo cp -p ${PKGDIR}/${PKGFILE} ${PKGROOT}/${PKGFILE}
		fi
done
