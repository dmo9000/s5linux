#!/bin/sh
set -e

MOCKBUILDS="./mockbuilds"

PROJECT=${1}
	if [ ! -x "${PROJECT}" ]; then 
		echo "Cannot find project script ${PROJECT}"
		exit 1
		fi

HAS_BUILDREQUIRES=`grep "^BUILDREQUIRES=" ${PROJECT} | wc -l`
HAS_BUILDVALIDATOR=`grep "build-validator" ${PROJECT} | wc -l`

eval `grep "^BUILDREQUIRES=" ${PROJECT}`
eval `grep "^PKG=" ${PROJECT} | head -n 1`
eval `grep "^VERSION=" ${PROJECT} | head -n 1`
eval `grep "^PKGID=" ${PROJECT} | head -n 1`

if [ -z "${PKGID}" ]; then 
	echo "*** Packaging script is missing PKGID. Aborting"
	exit 1
fi

if [ ${HAS_BUILDREQUIRES} -eq 0 ]; then 
	echo "*** mockbuild requires BUILDREQUIRES field in project"
	exit 1
	fi

if [ ${HAS_BUILDVALIDATOR} -eq 0 ]; then 
	echo "*** mockbuild requires build-validator support"
	exit 1
	fi

echo "* Project has PKGID         = ${PKGID}"
echo "* Project has PKG           = ${PKG}"
echo "* Project has VERSION       = ${VERSION}"
echo "* Project has BUILDREQUIRES = ${BUILDREQUIRES}"
eval `grep "^PKGNAME=" ${PROJECT} | head -n 1`
echo "* Project has PKGNAME       = ${PKGNAME}"

if [ -z "${PROJECT}" ]; then
	echo "Need to specify a package project to build."
	exit 1
	fi

if [ ! -r "${PROJECT}" ]; then
	echo "Need to specify a package project to build that actually exists."
	exit 1
	fi


if [ ! -d install-root ]; then
	echo "install-root is not found ; perform toplevel build to create it"
	exit 1
fi

if [ -d "${MOCKBUILDS}/${PROJECT}" ]; then 
	echo "* Cleaning up old ${MOCKBUILDS}/${PROJECT} ..."
	sudo rm -rf "./${MOCKBUILDS}/${PROJECT}"
	fi

echo "* Cloning install-root to ${MOCKBUILDS}/${PROJECT} ..."
mkdir -p ${MOCKBUILDS}/${PROJECT}
sudo cp -rfp install-root/* ${MOCKBUILDS}/${PROJECT}
sudo cp ${PROJECT} ${MOCKBUILDS}/${PROJECT}/${PROJECT}
sudo cp *.pkgs ${MOCKBUILDS}/${PROJECT}/packages
echo "* Syncing latest package updates ..."
sudo rsync -a spool/*.pkg.gz ${MOCKBUILDS}/${PROJECT}/packages/

if [ ! -z "${BUILDREQUIRES}" ]; then
	echo "* Bootstrapping BUILDREQUIRES package sets ($BUILDREQUIRES) ..."
	for PKGLIST in ${BUILDREQUIRES}; do 
		echo "   - set: ${PKGLIST}"
		sudo chroot ${MOCKBUILDS}/${PROJECT} /bootstrap.sh /packages/${PKGLIST} | sed -e "s/^/     /"
	done
	fi

# set up build chamber

sudo chroot ${MOCKBUILDS}/${PROJECT} mkdir -p /home/mockbuild
sudo chroot ${MOCKBUILDS}/${PROJECT} groupadd -g 65533 mockbuild
sudo chroot ${MOCKBUILDS}/${PROJECT} useradd -u 65533 -g 65533 mockbuild
sudo chroot ${MOCKBUILDS}/${PROJECT} usermod -G wheel mockbuild
sudo cp ${PROJECT} ${MOCKBUILDS}/${PROJECT}/home/mockbuild/${PROJECT}
sudo cp build-validator.sh ${MOCKBUILDS}/${PROJECT}/home/mockbuild/build-validator.sh
sudo cp mkproto.sh ${MOCKBUILDS}/${PROJECT}/home/mockbuild/mkproto.sh
sudo cp mkpkg.sh ${MOCKBUILDS}/${PROJECT}/home/mockbuild/mkpkg.sh
sudo cp mkstream.sh ${MOCKBUILDS}/${PROJECT}/home/mockbuild/mkstream.sh
sudo mkdir -p ${MOCKBUILDS}/${PROJECT}/home/mockbuild/{src,pkgbuild,spool}
sudo cp -pr patches ${MOCKBUILDS}/${PROJECT}/home/mockbuild/patches
sudo cp -pr configs ${MOCKBUILDS}/${PROJECT}/home/mockbuild/configs
sudo cp -pr lfs-bootscripts ${MOCKBUILDS}/${PROJECT}/home/mockbuild/lfs-bootscripts
sudo cp -rp install-root ${MOCKBUILDS}/${PROJECT}/home/mockbuild/

# copy sources

for SOURCE in `find src -maxdepth 1 -name "${PKGNAME}.*" -type f`; do
       echo "  - installing source archive ${SOURCE}"
       sudo cp -v ${SOURCE} ${MOCKBUILDS}/${PROJECT}/home/mockbuild/${SOURCE}
done

# set timezone in mockbuild container

sudo chroot ${MOCKBUILDS}/${PROJECT} /bin/bash -c "ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime"

sudo chroot ${MOCKBUILDS}/${PROJECT} chown -R mockbuild:mockbuild /home/mockbuild
sudo chroot ${MOCKBUILDS}/${PROJECT} sudo -u mockbuild \
	/bin/bash -c "cd /home/mockbuild && /home/mockbuild/${PROJECT}"

echo "*** Importing packages back from mockbuild to spool ..."

cp -v ${MOCKBUILDS}/${PROJECT}/home/mockbuild/spool/${PKGID}.pkg.gz spool/${PKGID}.pkg.gz

echo "*** Cleaning up build container"
sudo rm -rf ./${MOCKBUILDS}/${PROJECT}
