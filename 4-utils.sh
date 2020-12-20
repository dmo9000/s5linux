#!/bin/sh
TOPLEVEL=`pwd`
NPROC=`nproc`
#TOPLEVEL=`echo $TOPLEVEL | sed 's,\/,\\\/,g'`
sed -i "s/^CFLAGS=.*/CFLAGS=-static/g" heirloom-project/heirloom/heirloom/makefile
sed -i "s/^CFLAGS.*/CFLAGS = -D_DEFAULT_SOURCE \"-static\"/g" heirloom-project/heirloom/heirloom/build/mk.config
sed -i "s/^LDFLAGS=.*/LDFLAGS=-static/g" heirloom-project/heirloom/heirloom/makefile
sed -i "s/^LDFLAGS.*/LDFLAGS = -D_DEFAULT_SOURCE \"-static\"/g" heirloom-project/heirloom/heirloom/build/mk.config
sed -i "s/^LCURS.*/LCURS = -lncurses -ltinfo/g" heirloom-project/heirloom/heirloom/build/mk.config
sed -i "s/USE_ZLIB.*/USE_ZLIB=0/g" heirloom-project/heirloom/heirloom/build/mk.config
sed -i "s/^LIBZ.*/#LIBZ=/g" heirloom-project/heirloom/heirloom/build/mk.config 

cd heirloom-project/heirloom/heirloom/ 
make CFLAGS=-static LDFLAGS=-static
#make -j ${NPROC}
make
sudo make ROOT=${TOPLEVEL}/install-root install
