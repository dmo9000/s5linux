#!/bin/sh
TOPLEVEL=`pwd`
NPROC=`nproc`
TOPLEVEL=`echo $TOPLEVEL | sed 's,\/,\\\/,g'`
# cp patches/heirloom-project/heirloom/heirloom-pkgtools/libpkg/verify.c heirloom-project/heirloom/heirloom-pkgtools/libpkg/verify.c
set -x
#sed -i "s/^int\septnum/extern int eptnum/g" heirloom-project/heirloom/heirloom-pkgtools/pkgcmds/installf/main.c
find heirloom-project/heirloom/heirloom-pkgtools -name "*.c*" -print | xargs sed -i 's/^#include <stropts.h>//'
find heirloom-project/heirloom/heirloom-pkgtools -name "*.c*" -print | xargs sed -i 's/^#\sinclude <stropts.h>//'
sed -i "s/^CFLAGS=.*/CFLAGS=-static/g" heirloom-project/heirloom/heirloom-pkgtools/mk.config
sed -i "s/^LDFLAGS=.*/LDFLAGS=-static/g" heirloom-project/heirloom/heirloom-pkgtools/mk.config
set +x
cd heirloom-project/heirloom/heirloom-pkgtools/ 
make -j ${NPROC}
sudo make ROOT=${TOPLEVEL}/install-root install
