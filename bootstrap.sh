#!/usr/5bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/5bin
PKGPATH=`dirname ${1}`
PKGLIST=`basename ${1}`
PKGNAMES=`/usr/5bin/cat ${PKGPATH}/${PKGLIST}`

status2message()
{
	case ${1} in 
		0)
		printf "\x1b[92m[OK]\x1b[0m"	
		;;		
		2)
		printf "\x1b[93m[WARNING]\x1b[0m"
		;;
		*)
		printf "\x1b[91m[ERROR=${1}]\x1b[0m"
		exit 1
		;;
	esac

}

for PKG in ${PKGNAMES} ; do 
	#echo "-> ${PKG}"
	if [ ! -r "${PKGPATH}/${PKG}.pkg" ]; then
		if [ -r "${PKGPATH}/${PKG}.pkg.gz" ]; then
			PKGSIZE=`/usr/5bin/ls -sh ${PKGPATH}/${PKG}.pkg.gz  | /usr/5bin/awk '{ print $1; }'`
			printf "[C] Installing package ${PKGPATH}/${PKG}.pkg.gz (${PKGSIZE}) ... "
			/bin/gzip -d -c -k "${PKGPATH}/${PKG}.pkg.gz" > /var/spool/pkg/${PKG}.pkg
			( echo 1 && yes) | pkgadd -d /var/spool/pkg/${PKG}.pkg  1>/dev/null 2>&1
			status2message $?
			#STATUS=$?
			#echo $STATUS
			/sbin/ldconfig
			rm -f /var/spool/pkg/${PKG}.pkg
			else 
			echo "[?] No package found for ${PKG} ; skipping"
			fi	
		else
		PKGSIZE=`/usr/5bin/ls -sh ${PKGPATH}/${PKG}.pkg  | /usr/5bin/awk '{ print $1; }'`
		printf "[U] Installing package ${PKGPATH}/${PKG}.pkg (${PKGSIZE}) ... "
		( echo 1 && yes) | pkgadd -d ${PKGPATH}/${PKG}.pkg  1>/dev/null 2>&1
		status2message $?
		#STATUS=$?
		#echo $STATUS
		/sbin/ldconfig
		fi
	done

/sbin/ldconfig
exit 0
