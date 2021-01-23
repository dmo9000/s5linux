
echo "+++ build validator: [$0] [$*]"

# test script passes dry-run

bash -n $0 $* || exit 1


HAS_SET_E=`grep "^set -e" ${0}`
if [ -z "${HAS_SET_E}" ]; then 
	echo "error: ${0} doesn't contain 'set -e' directive"
	exit 1
	fi

set -x
HAS_PKGID=`grep "^PKGID=" ${0}`
if [ -z "${HAS_PKGID}" ]; then 
	echo "error: ${0} doesn't contain PKGID directive"
	exit 1
	fi
set +x

HAS_MAKEPKG=`grep "^../../mkpkg.sh" ${0}`
if [ -z "${HAS_MAKEPKG}" ]; then 
	echo "error: ${0} doesn't contain 'makepkg' directive"
	exit 1
	fi

HAS_NULLVERSION=`grep "^VERSION=000000" ${0}`
if [ ! -z "${HAS_NULLVERSION}" ]; then 
	echo "error: ${0} has invalid VERSION (000000) - please fix"
	exit 1
	fi


build_require()
{
	REQUIRE=`which ${1}`
	if [ -z "${REQUIRE}" ]; then 
		echo "+++ can't find required build tool ${1}"
		exit 1
	fi

}
