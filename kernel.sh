#!/bin/sh
TOPLEVEL=`pwd`
NPROC=`nproc`
cd src 
tar -zxvf linux-5.10.1.tar.gz
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
