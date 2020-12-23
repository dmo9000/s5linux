#!/bin/sh
TOPLEVEL=`pwd`
NPROC=`nproc`
#TOPLEVEL=`echo $TOPLEVEL | sed 's,\/,\\\/,g'`

rm -rf ./heirloom-project
rm -rf ./heirloom-project.orig

rm -rf ./install-root
git clone https://github.com/eunuchs/heirloom-project.git

# global fixes for stropts.h (not used on Linux)

find heirloom-project -name "*.c*" -print | xargs sed -i 's/^#include <stropts.h>//'
find heirloom-project -name "*.c*" -print | xargs sed -i 's/^#\sinclude <stropts.h>//'
find heirloom-project -name "*.c*" -print | xargs sed -i 's/^#include <sys\/mkdev.h>/#include <sys\/sysmacros.h>/'

# force SHELL to /bin/sh everywhere

find heirloom-project -name "[Mm]akefile" -print | xargs sed -i 's/^SHELL = .*/SHELL=\/bin\/sh/g'
find heirloom-project -name "mk.config" -print | xargs sed -i 's/^SHELL = .*/SHELL=\/bin\/sh/g'
find heirloom-project -name "mk.config" -print | xargs sed -i "s/^INSTALL=.*/INSTALL=\/usr\/bin\/install/g"

# heirloom patches

cp -v patches/heirloom-project/heirloom/heirloom/heirloom.spec heirloom-project/heirloom/heirloom/heirloom.spec
cd heirloom-project/heirloom/heirloom
patch -p1 < ../../../heirloom-tools-070715-glibc-2.31.patch
patch -p1 < ../../../heirloom-tools-070715-gcc-10.patch
patch -p1 < ../../../heirloom-tools-201215-major.patch
cd ${TOPLEVEL}

# heirloom-devtools patches

find heirloom-project -name "bsd.cc" -print | xargs sed -i 's/auto SIG_PF/SIG_PF/g'
find heirloom-project -name "pmake.cc" -print | xargs sed -i "s/rpc\/rpc.h/tirpc\/rpc\/rpc.h/"
sed -i "s/^\(XFLAGS = \)\(.*\)$/\1 -I\/usr\/include\/tirpc \2/g" heirloom-project/heirloom/heirloom-devtools/make/src/Makefile.mk
sed -i "s/CXXFLAGS=.*/CXXFLAGS=-fpermissive/g" heirloom-project/heirloom/heirloom-devtools/mk.config
cp -v patches/heirloom-project/heirloom/heirloom-devtools/heirloom-devtools.spec heirloom-project/heirloom/heirloom-devtools/heirloom-devtools.spec


# heirloom-pkgtools patches

cp -v patches/heirloom-project/heirloom/heirloom-pkgtools/heirloom-pkgtools.spec heirloom-project/heirloom/heirloom-pkgtools/heirloom-pkgtools.spec
find heirloom-project/heirloom/heirloom-pkgtools  -name "*.c" -print | xargs sed -i 's/#include "p12lib.h"//'
cp patches/heirloom-project/heirloom/heirloom-pkgtools/libpkg/verify.c heirloom-project/heirloom/heirloom-pkgtools/libpkg/verify.c
sed -i "s/^int\septnum/extern int eptnum/g" heirloom-project/heirloom/heirloom-pkgtools/pkgcmds/installf/main.c
cd ${TOPLEVEL}/heirloom-project
patch -p1 < ../heirloom-pkgtools-000000-sane-canonize.patch

# take backup for diffing

cd ${TOPLEVEL}
cp -rfp heirloom-project heirloom-project.orig
