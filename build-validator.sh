
echo "+++ build validator: [$0] [$*]"

# test script passes dry-run

bash -n $0 $* || exit 1

# test script contains "set -e"

HAS_SET_E=`grep "^set -e" ${0}`
if [ -z "${HAS_SET_E}" ]; then 
	echo "error: ${0} doesn't contain 'set -e' directive"
	exit 1
	fi

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
