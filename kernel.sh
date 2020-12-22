#!/bin/sh
TOPLEVEL=`pwd`
NPROC=`nproc`
cd src 
tar -zxvf linux-5.10.1.tar.gz
cd linux-5.10.1
make defconfig
time make -j ${NPROC} bzImage
time make -j 4 modules

cd ${TOPLEVEL}
cp src/linux-5.10.1/arch/x86_64/boot/bzImage kernel/bzImage
