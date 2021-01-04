sudo rm -rf pkgbuild/cde-2.3.2-configs 
mkdir -p pkgbuild/cde-2.3.2-configs
sudo cp -rfp install-root/* pkgbuild/cde-2.3.2-configs
sudo cp -rfp src/cde-2.3.2 pkgbuild/cde-2.3.2-configs/
sed -i 's/^\s*CLEAN_DAEMONS.*/  CLEAN_DAEMONS="no"/' \
	pkgbuild/cde-2.3.2-configs/cde-2.3.2/admin/IntegTools/dbTools/installCDE
grep '^\s*CLEAN_DAEMONS=' \
	pkgbuild/cde-2.3.2-configs/cde-2.3.2/admin/IntegTools/dbTools/installCDE
grep "LOCATION=" \
	pkgbuild/cde-2.3.2-configs/cde-2.3.2/admin/IntegTools/dbTools/installCDE
cp container-cde-config.sh pkgbuild/cde-2.3.2-configs/

sudo chroot pkgbuild/cde-2.3.2-configs /container-cde-config.sh
sudo find pkgbuild/cde-2.3.2-configs -mindepth 1 \
	! -regex "^pkgbuild/cde-2.3.2-configs\/etc\/dt\(/.*\)?" \
	! -regex "^pkgbuild/cde-2.3.2-configs\/var\/dt\(/.*\)?" \
	! -regex "^pkgbuild/cde-2.3.2-configs\/usr\/dt\(/.*\)?" \
	-delete


