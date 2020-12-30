#!/bin/sh
set -e
set -x
TOPLEVEL=`pwd`
NPROC=`nproc`
#TOPLEVEL=`echo $TOPLEVEL | sed 's,\/,\\\/,g'`
#sed -i "s/^ROOT=.*/ROOT=$TOPLEVEL\/install-root/g" heirloom-project/heirloom/heirloom-sh/makefile
#sed -i "s/^CFLAGS=.*/CFLAGS=-static/g" heirloom-project/heirloom/heirloom-sh/makefile
#sed -i "s/^LDFLAGS=.*/LDFLAGS=-static/g" heirloom-project/heirloom/heirloom-sh/makefile
#sed -i "s/^UCBINST=.*/UCBINST=\/usr\/bin\/install/g" heirloom-project/heirloom/heirloom-sh/makefile
cd heirloom-project/heirloom/heirloom-sh/ 
make LDFLAGS="-static" CFLAGS="-static" UCBINST="/usr/bin/install" -j ${NPROC}
sudo make ROOT=${TOPLEVEL}/install-root UCBINST="/usr/bin/install" install
