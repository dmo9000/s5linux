#!/bin/sh
set -e
set -x
NPROC=`nproc`
TOPLEVEL=`pwd`
NPROC=`nproc`
#TOPLEVEL=`echo $TOPLEVEL | sed 's,\/,\\\/,g'`
#sed -i "s/^PREFIX=.*/PREFIX=$TOPLEVEL\/install-root\/usr\/ccs/g" heirloom-project/heirloom/heirloom-devtools/mk.config
#sed -i "s/^SUSBIN=.*/SUSBIN=$TOPLEVEL\/install-root\/usr\/5bin\/posix" heirloom-project/heirloom/heirloom-devtools/mk.config
sed -i "s/^SHELL.*/SHELL = \/bin\/sh/" heirloom-project/heirloom/heirloom-devtools/mk.config 
#sed -i "s/^\(XFLAGS = \)\(.*\)$/\1 -I\/usr\/include\/tirpc \2/g" heirloom-project/heirloom/heirloom-devtools/make/src/Makefile.mk
cd heirloom-project/heirloom/heirloom-devtools/ 
make -j ${NPROC}
sudo mkdir -p ${TOPLEVEL}/install-root/usr/5bin/posix/
sudo make ROOT=${TOPLEVEL}/install-root install
