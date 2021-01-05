#!/bin/sh

if [ ! -d "./install-root" ]; then
        echo "install-root/ is missing. Please fix this first." 
        exit 1
        fi

sudo rm -rf pkgbuild/cde-2.3.2 
mkdir -p pkgbuild/cde-2.3.2
sudo cp -rfp install-root/* pkgbuild/cde-2.3.2
sudo cp -rfp src/cde-2.3.2 pkgbuild/cde-2.3.2/
sed -i 's/^\s*CLEAN_DAEMONS.*/  CLEAN_DAEMONS="no"/' \
	pkgbuild/cde-2.3.2/cde-2.3.2/admin/IntegTools/dbTools/installCDE
grep '^\s*CLEAN_DAEMONS=' \
	pkgbuild/cde-2.3.2/cde-2.3.2/admin/IntegTools/dbTools/installCDE
grep "LOCATION=" \
	pkgbuild/cde-2.3.2/cde-2.3.2/admin/IntegTools/dbTools/installCDE
cp container-cde-config.sh pkgbuild/cde-2.3.2/
sudo mkdir -p pkgbuild/cde-2.3.2/usr/dt/lib
sudo mkdir -p pkgbuild/cde-2.3.2/usr/dt/config
sudo cp -p src/cde-2.3.2/programs/dtterm/dtterm.ti pkgbuild/cde-2.3.2/usr/dt/config
sudo chroot pkgbuild/cde-2.3.2 /container-cde-config.sh
sudo rm -rf pkgbuild/cde-2.3.2/cde-2.3.2
sudo find pkgbuild/cde-2.3.2 -mindepth 1 \
	! -regex "^pkgbuild\/cde-2.3.2\/etc\/dt\(/.*\)?" \
	! -regex "^pkgbuild\/cde-2.3.2\/var\/dt\(/.*\)?" \
	! -regex "^pkgbuild\/cde-2.3.2\/usr\/dt\(/.*\)?" \
	-delete
# what on earth ...
#sudo find pkgbuild/cde-2.3.2 -name '\*' -delete

# tests
[ -d pkgbuild/cde-2.3.2/usr/dt/dthelp ] || echo "/usr/dt/dthelp is missing"
#find pkgbuild/cde-2.3.2 -name "*.UTF-8"
