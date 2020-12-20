#!/bin/sh

TOPLEVEL=`pwd`

cat <<EOF > ~/.rpmmacros
%_topdir $HOME/rpmbuild
%_tmppath $HOME/rpmbuild/tmp
EOF

mkdir -p ~/rpmbuild
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS,tmp}
mkdir -p ~/rpmbuild/RPMS/`uname -p`
mkdir -p ~/rpmbuild/RPMS/noarch

find ./heirloom-project -type f -name "*.spec" -exec cp {} ~/rpmbuild/SPECS/ \;
sed -i "s/-D__NO_STRING_INLINES/-D__NO_STRING_INLINES -fpermissive/g" ~/rpmbuild/SPECS/heirloom-devtools.spec

# heirloom snapshot


cd ${TOPLEVEL}/heirloom-project/heirloom
ln -sf heirloom heirloom-040306 
tar -hpcvf ~/rpmbuild/SOURCES/heirloom-040306.tar heirloom-040306
rm -f heirloom-040306
bzip2 -f ~/rpmbuild/SOURCES/heirloom-040306.tar

# devtools snapshot

cd ${TOPLEVEL}/heirloom-project/heirloom
ln -sf heirloom-devtools heirloom-devtools-000000
tar -hpcvf ~/rpmbuild/SOURCES/heirloom-devtools-000000.tar heirloom-devtools-000000
rm -f heirloom-devtools-000000
bzip2 -f ~/rpmbuild/SOURCES/heirloom-devtools-000000.tar

# pkgtools snapshot

cd ${TOPLEVEL}/heirloom-project/heirloom
ln -sf heirloom-pkgtools heirloom-pkgtools-000000
tar -hpcvf ~/rpmbuild/SOURCES/heirloom-pkgtools-000000.tar heirloom-pkgtools-000000
rm -f heirloom-pkgtools-000000
bzip2 -f ~/rpmbuild/SOURCES/heirloom-pkgtools-000000.tar

