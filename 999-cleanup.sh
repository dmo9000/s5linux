#!/bin/sh

rm -rf ./heirloom-project*
sudo rm -rf ./install-root
for SRCDIR in `cat src/MANIFEST` ; do
	rm -rf src/$SRCDIR ; 
	done

rm -f ~/rpmbuild/SPECS/heirloom*spec
rm -f ~/rpmbuild/SOURCES/heirloom*bz2

cd src && ./cleanup.sh	


