#!/bin/sh

die()
{
        echo "$*"
        exit 1
}

INSTALL_ROOT="${1}"
[ ! -z "${INSTALL_ROOT}" ] || die "Install root not specified."


sudo cp *.pkgs ${INSTALL_ROOT}/packages/
sudo cp bootstrap.sh ${INSTALL_ROOT}/bootstrap.sh
sudo chroot ${INSTALL_ROOT} /bootstrap.sh /packages/bootstrap.pkgs
