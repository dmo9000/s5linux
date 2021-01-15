#!/usr/5bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/5bin

status2message()
{
	case ${1} in 
		0)
		printf "\x1b[92m[OK]\x1b[0m\n"	
		;;		
		2)
		printf "\x1b[93m[WARNING]\x1b[0m\n"
		;;
		*)
		printf "\x1b[91m[ERROR=${1}]\x1b[0m\n"
		exit 1
		;;
	esac

}

for CUR_PKGLIST in ${@}; do
        PKGPATH=`dirname ${CUR_PKGLIST}`
        PKGLIST=`basename ${CUR_PKGLIST}`
        PKGNAMES=`/usr/5bin/cat ${PKGPATH}/${PKGLIST}`

	for PKG in ${PKGNAMES} ; do 
		#echo "-> ${PKG}"
		if [ ! -r "${PKGPATH}/${PKG}.pkg" ]; then
			if [ -r "${PKGPATH}/${PKG}.pkg.gz" ]; then
				PKGSIZE=`/usr/5bin/ls -sh ${PKGPATH}/${PKG}.pkg.gz  | /usr/5bin/awk '{ print $1; }'`
				printf "%-75s" "[C] Installing ${PKGPATH}/${PKG}.pkg.gz (${PKGSIZE}) ... "
				gzip -d -c -k "${PKGPATH}/${PKG}.pkg.gz" > /var/spool/pkg/${PKG}.pkg
				( echo 1 && yes) | pkgadd -d /var/spool/pkg/${PKG}.pkg  1>/dev/null 2>&1
				status2message $?
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
			/sbin/ldconfig
			fi
		done
	done

/sbin/ldconfig
exit 0
