#!/bin/sh
TOPLEVEL=`pwd`
NPROC=`nproc`
cd src 
tar -zxvf linux-5.10.1.tar.gz
convert ${TOPLEVEL}/graphics/syslinux.png src/linux-5.10.1/drivers/video/logo/headrat-linux.ppm
ppmquant 224 src/linux-5.10.1/drivers/video/logo/headrat-linux.ppm > src/linux-5.10.1/drivers/video/logo/headrat-linux-224.ppm
pnmnoraw src/linux-5.10.1/drivers/video/logo/headrat-linux-224.ppm > src/linux-5.10.1/drivers/video/logo/headrat-linux-224-ascii.ppm 
mv src/linux-5.10.1/drivers/video/logo/headrat-linux-224-ascii.ppm src/linux-5.10.1/drivers/video/logo/logo_linux_clut224.ppm
cd linux-5.10.1
cp ../../kernel.config .config
#make defconfig
sed -i "s/CONFIG_DEBUG_STACK_USAGE=y/CONFIG_DEBUG_STACK_USAGE=n/g" .config
#echo "CONFIG_FONT_SUN8x16=y" >> .config
cp .config .config.current

time make -j ${NPROC} bzImage
time make -j 4 modules

cd ${TOPLEVEL}
cp src/linux-5.10.1/arch/x86_64/boot/bzImage kernel/bzImage
