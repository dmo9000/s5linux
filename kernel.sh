#!/bin/sh
set -e

TOPLEVEL=`pwd`
NPROC=`nproc`
cd src 
rm -rf linux-5.10.1
tar -zxvf linux-5.10.1.tar.gz
#convert ${TOPLEVEL}/graphics/syslinux.png ${TOPLEVEL}/src/linux-5.10.1/drivers/video/logo/headrat-linux.ppm
#ppmquant 224 ${TOPLEVEL}/src/linux-5.10.1/drivers/video/logo/headrat-linux.ppm > ${TOPLEVEL}/src/linux-5.10.1/drivers/video/logo/headrat-linux-224.ppm
#pnmnoraw ${TOPLEVEL}/src/linux-5.10.1/drivers/video/logo/headrat-linux-224.ppm > ${TOPLEVEL}/src/linux-5.10.1/drivers/video/logo/headrat-linux-224-ascii.ppm 
#mv ${TOPLEVEL}/src/linux-5.10.1/drivers/video/logo/headrat-linux-224-ascii.ppm ${TOPLEVEL}/src/linux-5.10.1/drivers/video/logo/logo_linux_clut224.ppm
cd linux-5.10.1
cp ../../kernel.config .config
#make defconfig
sed -i "s/CONFIG_DEBUG_STACK_USAGE=y/CONFIG_DEBUG_STACK_USAGE=n/g" .config
#echo "CONFIG_FONT_SUN8x16=y" >> .config
cp .config .config.current

time make -j ${NPROC} bzImage
time make -j 4 modules
time make -j 4 headers_install ARCH=x86_64 INSTALL_HDR_PATH=../../build/kernel-headers/usr
rm -rf ../../pkgbuild/kernel-modules
mkdir -p ../../pkgbuild/kernel-modules
time make INSTALL_MOD_PATH=../../pkgbuild/kernel-modules modules_install

cd ${TOPLEVEL}
cp src/linux-5.10.1/arch/x86_64/boot/bzImage kernel/bzImage
cd ${TOPLEVEL}
./400-kernel-headers.sh
./409-kernel-modules.sh
./410-kernel.sh
