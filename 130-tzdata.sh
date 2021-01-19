#!/bin/sh
#

# setup
#
set -e
#
BUILDREQUIRES=""
PKGID=S5LXtzdata
PKG=tzdata
VERSION=2020f
PKGNAME=${PKG}${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
rm -rf ./${PKGNAME}
mkdir ${PKGNAME} && cd ${PKGNAME}
tar -zxvf ../${PKGNAME}.tar.gz

# configure/build/install

ZONEINFO=/usr/share/zoneinfo
mkdir -pv ${PKGDIR}/$ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
            asia australasia backward ; do
   zic -L /dev/null   -d ${PKGDIR}/$ZONEINFO       -y "sh yearistype.sh" ${tz}
   zic -L /dev/null   -d ${PKGDIR}/$ZONEINFO/posix -y "sh yearistype.sh" ${tz}
   zic -L leapseconds -d ${PKGDIR}/$ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab ${PKGDIR}/$ZONEINFO
zic -d ${PKGDIR}/$ZONEINFO -p Australia/Melbourne 
unset ZONEINFO

# package

cd ${PKGDIR}
PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=tzdata
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

../../mkproto.sh
../../mkpkg.sh
