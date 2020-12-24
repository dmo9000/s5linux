#!/usr/5bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/5bin
PKGPATH=`dirname ${1}`
PKGLIST=`basename ${1}`
for PKG in `/usr/5bin/cat ${PKGPATH}/${PKGLIST}` ; do 
	PKGSIZE=`/usr/5bin/ls -sh ${PKGPATH}/${PKG}.pkg  | /usr/5bin/awk '{ print $1; }'`
	if [ ! -r "${PKGPATH}/${PKG}.pkg" ]; then
	       	echo "Cannot acess ${PKGPATH}/${PKG}.pkg!"
       		exit 1
 		fi		
	echo "Installing package ${PKGPATH}/${PKG}.pkg (${PKGSIZE}) ... "
	( echo 1 && yes) | pkgadd -d ${PKGPATH}/${PKG}.pkg  1>/dev/null 2>&1
	/sbin/ldconfig
	done

/sbin/ldconfig
exit 0
