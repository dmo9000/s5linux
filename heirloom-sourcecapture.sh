#!/bin/sh

TOPLEVEL=`pwd`
set -x

# heirloom snapshot

cd ${TOPLEVEL}/heirloom-project/heirloom
ln -sf heirloom heirloom-040306 
tar -hpcvf ${TOPLEVEL}/src/heirloom-040306.tar heirloom-040306
rm -f heirloom-040306
gzip -9 -f ${TOPLEVEL}/src/heirloom-040306.tar

# heirloom shell snapshot

cd ${TOPLEVEL}/heirloom-project/heirloom
ln -sf heirloom-sh heirloom-sh-000000
tar -hpcvf ${TOPLEVEL}/src/heirloom-sh-000000.tar heirloom-sh-000000
rm -f heirloom-sh-000000
gzip -9 -f ${TOPLEVEL}/src/heirloom-sh-000000.tar

# devtools snapshot

cd ${TOPLEVEL}/heirloom-project/heirloom
ln -sf heirloom-devtools heirloom-devtools-000000
tar -hpcvf ${TOPLEVEL}/src/heirloom-devtools-000000.tar heirloom-devtools-000000
rm -f heirloom-devtools-000000
gzip -9 -f ${TOPLEVEL}/src/heirloom-devtools-000000.tar

# pkgtools snapshot

cd ${TOPLEVEL}/heirloom-project/heirloom
ln -sf heirloom-pkgtools heirloom-pkgtools-000000
tar -hpcvf ${TOPLEVEL}/src/heirloom-pkgtools-000000.tar heirloom-pkgtools-000000
rm -f heirloom-pkgtools-000000
gzip -9 -f ${TOPLEVEL}/src/heirloom-pkgtools-000000.tar

