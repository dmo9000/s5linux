#!/bin/sh

die()
{
        echo "$*"
        exit 1
}

INSTALL_ROOT="${1}"
[ ! -z "${INSTALL_ROOT}" ] || die "Install root not specified."

PKGCOUNT=`ls -1 ./spool/*.pkg 2>/dev/null | wc -l`
GZPKGCOUNT=`ls -1 ./spool/*.pkg.gz 2>/dev/null | wc -l`
echo "PKGCOUNT="${PKGCOUNT}

#for PKG in `ls -1 ./spool/*.pkg 2>/dev/null` ; do 
for PKG in `cat bootstrap.pkgs`; do
	FILENAME=`basename ${PKG}`
	FILENAME="${FILENAME}.pkg"
	ZFILENAME=${FILENAME}.gz
	if [ "spool/${FILENAME}" -nt "spool/${ZFILENAME}" ] || [ ! -r "spool/${ZFILENAME}" ]; then
		echo "Compressing package ${FILENAME} to ${ZFILENAME} ..."
		#gzip -f -9 -k "spool/${FILENAME}"
		pigz -f -9 -k "spool/${FILENAME}"
		touch "spool/${FILENAME}.gz"
		fi
	done

GZPKGCOUNT=`ls -1 ./spool/*.pkg.gz 2>/dev/null | wc -l`
echo "GZPKGCOUNT="${GZPKGCOUNT}
for GZPKG in `ls -1 ./spool/*.pkg.gz` ; do 
	ZFILENAME=`basename ${GZPKG}`
	sudo cp "spool/${ZFILENAME}" ${INSTALL_ROOT}/packages/"${ZFILENAME}"
	done

