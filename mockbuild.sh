#!/bin/sh
set -e

CONBUILDS="./conbuilds"
PROJECT=${1}

eval `grep "^BUILDREQUIRES=" ${PROJECT}`
eval `grep "^PKG=" ${PROJECT} | head -n 1`
eval `grep "^VERSION=" ${PROJECT} | head -n 1`

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

if [ -d "${CONBUILDS}/${PROJECT}" ]; then 
	echo "* Cleaning up old ${CONBUILDS}/${PROJECT} ..."
	sudo rm -rf "./${CONBUILDS}/${PROJECT}"
	fi

echo "* Cloning install-root to ${CONBUILDS}/${PROJECT} ..."
mkdir -p ${CONBUILDS}/${PROJECT}
sudo cp -rfp install-root/* ${CONBUILDS}/${PROJECT}
sudo cp ${PROJECT} ${CONBUILDS}/${PROJECT}/${PROJECT}

if [ ! -z "${BUILDREQUIRES}" ]; then
	echo "* Bootstrapping BUILDREQUIRES package sets ($BUILDREQUIRES) ..."
	for PKGLIST in ${BUILDREQUIRES}; do 
		echo "   - set: ${PKGLIST}"
		sudo chroot ${CONBUILDS}/${PROJECT} /bootstrap.sh /packages/${PKGLIST} | sed -e "s/^/     /"
	done
	fi

# set up build chamber

sudo chroot ${CONBUILDS}/${PROJECT} mkdir -p /home/mockbuild
sudo chroot ${CONBUILDS}/${PROJECT} groupadd -g 65533 mockbuild
sudo chroot ${CONBUILDS}/${PROJECT} useradd -u 65533 -g 65533 mockbuild
sudo chroot ${CONBUILDS}/${PROJECT} usermod -G wheel mockbuild
sudo cp ${PROJECT} ${CONBUILDS}/${PROJECT}/home/mockbuild/${PROJECT}
sudo cp build-validator.sh ${CONBUILDS}/${PROJECT}/home/mockbuild/build-validator.sh
sudo cp mkproto.sh ${CONBUILDS}/${PROJECT}/home/mockbuild/mkproto.sh
sudo cp mkpkg.sh ${CONBUILDS}/${PROJECT}/home/mockbuild/mkpkg.sh
sudo cp mkstream.sh ${CONBUILDS}/${PROJECT}/home/mockbuild/mkstream.sh
sudo mkdir -p ${CONBUILDS}/${PROJECT}/home/mockbuild/{src,pkgbuild,spool}
sudo cp -prv configs ${CONBUILDS}/${PROJECT}/home/mockbuild/configs

# copy sources

for SOURCE in `find src -maxdepth 1 -name "${PKGNAME}.*" -type f`; do
       echo "  - installing source archive ${SOURCE}"
       sudo cp -v ${SOURCE} ${CONBUILDS}/${PROJECT}/home/mockbuild/${SOURCE}
done

sudo chroot ${CONBUILDS}/${PROJECT} chown -R mockbuild:mockbuild /home/mockbuild

sudo chroot ${CONBUILDS}/${PROJECT} sudo -u mockbuild \
	/bin/bash -c "cd /home/mockbuild && /home/mockbuild/${PROJECT}"

