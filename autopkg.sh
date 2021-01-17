#!/bin/sh

ARCHIVE_IP=192.168.20.50
SPOOL=/var/spool/pkg
BRANCH="head"
BASEURL=http://${ARCHIVE_IP}/s5linux/${BRANCH}
COMMAND=${1}

usage()
{

	echo "usage: foo bar baz" 
	exit 1

}

verlte() {
    [ "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

spool_cleanup()
{
	# echo ""
	# echo -n "Cleaning up package ${PACKAGE} ... " 
	rm -f ${SPOOL}/autopkg.pkgs
	rm -rf ${SPOOL}/_autopkg/${PACKAGE}
	rm -f ${SPOOL}/${PACKAGE}.pkg
	rm -f ${SPOOL}/${PACKAGE}.pkg.gz
	# echo "okay"	
	echo ""
}

package_install()
{
	PACKAGE=${1}
	if [ -z "${PACKAGE}" ]; then 
		echo "$0 install <pkgname>"
		usage
		fi

	echo ""

	PKG_INSTALLED=`pkginfo -l ${PACKAGE} 1>/dev/null 2>&1 ; echo $?`

	if [ ${PKG_INSTALLED} -eq 0 ]; then 
		echo "Package '${PACKAGE}' is already installed"
		echo ""
		INST_VERSION=`pkginfo -l ${PACKAGE} | grep VERSION | sed -e "s/.*\ //"`
		INST_PSTAMP=`pkginfo -l ${PACKAGE} | grep PSTAMP | sed -e "s/.*\ //"`
		# echo " VERSION: ${INST_VERSION}"
		# echo " PSTAMP:  ${INST_PSTAMP}"
		# echo ""
	fi


	# retrieve package from archive if available


	URL="${BASEURL}/${PACKAGE}.pkg.gz"
	echo -n "Downloading ${URL} ... "
	curl --fail ${URL} -o ${SPOOL}/${PACKAGE}.pkg.gz 1>/dev/null 2>&1
	STATUS=$?

	case ${STATUS} in 
		22)
		echo ""
		echo "Package not found (HTTP 404):"
	       	echo ""
		echo "	$BASEURL/${PACKAGE}.pkg.gz"
	       	echo ""
		exit 1
		;;
		0)
		echo "okay"
		;;
		*)
		echo "unknown error from curl: ${STATUS}"
		exit ${STATUS}
		;;
	esac
 
	echo -n "Decompressing package ${SPOOL}/${PACKAGE}.pkg.gz ... "
	gunzip -f -k ${SPOOL}/${PACKAGE}.pkg.gz
	SIGNATURE=`head -n 1 ${SPOOL}/${PACKAGE}.pkg`
	if [ "${SIGNATURE}" != "# PaCkAgE DaTaStReAm" ]; then 
		echo "invalid package format"
		exit 1
		fi
	echo "okay"

	echo -n "Reading package metadata ... "
	mkdir -p ${SPOOL}/_autopkg
	rm -rf ${SPOOL}/_autopkg/${PACKAGE}
	(echo 1) | pkgtrans -o -i ${SPOOL}/${PACKAGE}.pkg ${SPOOL}/_autopkg 1>/dev/null 2>&1
	STATUS=$?
	if [ $STATUS -gt 0 ] ; then 
		echo "pkgtrans failed (exit status=$STATUS}"
		exit 1
		fi

	echo "okay"
	echo ""

	VERSION=`grep "^VERSION=.*$" ${SPOOL}/_autopkg/${PACKAGE}/pkginfo | sed -e "s/^.*=//"`
	PSTAMP=`grep "^PSTAMP=.*$" ${SPOOL}/_autopkg/${PACKAGE}/pkginfo | sed -e "s/^.*=//"`

	echo ""
	echo " VERSION: ${VERSION}"
	echo " PSTAMP:  ${PSTAMP}"
	echo ""

	if [ "${PKG_INSTALLED}" -eq 0 ] && [ "$INST_VERSION" != "000000" ]; then
		# overwriting installed package
		verlte "${VERSION}" "${INST_VERSION}" 
		VERSION_STATUS=$?
		if [ $VERSION_STATUS -eq 0 ]; then  
			echo "New package VERSION is newer or same version than installed package: "
		        echo "  (installed $INST_VERSION <= new ${VERSION})"
			verlte "${PSTAMP}" "${INST_PSTAMP}"
			PSTAMP_STATUS=$?
			if [ $PSTAMP_STATUS -eq	0 ]; then 
				echo ""
				echo "New package PSTAMP is same or older; not installing "
				echo "  (installed $INST_PSTAMP >= new ${PSTAMP})"
				spool_cleanup "{$PACKAGE}"
				exit 1
				else 
				echo "New package PSTAMP is not same, or is newer; installing "
				echo "  (installed ${INST_PSTAMP} < new ${PSTAMP})"
				echo "${PACKAGE}" > ${SPOOL}/autopkg.pkgs
				/bootstrap.sh ${SPOOL}/autopkg.pkgs
				spool_cleanup "{$PACKAGE}"
				fi

	       		else
		       	echo "New package is older than installed package: "
		        echo "  (installed $INST_VERSION > new ${VERSION})"
			spool_cleanup "{$PACKAGE}"
			exit 1
			fi
		else
	       	echo "New package installation: ${VERSION}.${PSTAMP}"
		rm -f ${SPOOL}/autopkgs.pkgs
		echo "${PACKAGE}" > ${SPOOL}/autopkg.pkgs
		/bootstrap.sh ${SPOOL}/autopkg.pkgs
		spool_cleanup "{$PACKAGE}"
		exit 0
	fi	


}

main()
{
	if [ -z "${COMMAND}" ]; then 
	usage
	fi

	case ${COMMAND} in 
		install)
		shift
		package_install $*
		;;
		remove)
		echo "$0 $1"
		;;
		list)
		echo "$0 $1"
		;;
		*)
		echo "$0: unknown command '${COMMAND}'"
		usage
		;;
	esac

	exit 0

}

# startup 

if [ "`whoami`" != "root" ]; then 
	echo "this program must be run as root"
	exit 1
fi

main $*
