#!/bin/sh

die()
{
        echo "$*"
        exit 1
}

INSTALL_ROOT="${1}"
[ ! -z "${INSTALL_ROOT}" ] || die "Install root not specified."

for PKG in `ls -1 ./spool/*.pkg` ; do 
	FILENAME=`basename ${PKG}`
	ZFILENAME=${FILENAME}.gz
	if [ "spool/${FILENAME}" -nt "spool/${ZFILENAME}" ] || [ ! -r "spool/${ZFILENAME}" ]; then
		echo "Compressing package ${FILENAME} to ${ZFILENAME} ..."
		#gzip -f -9 -k "spool/${FILENAME}"
		pigz -f -9 -k "spool/${FILENAME}"
		touch "spool/${FILENAME}.gz"
		fi
	sudo cp "spool/${ZFILENAME}" ${INSTALL_ROOT}/packages/"${ZFILENAME}"
	done

