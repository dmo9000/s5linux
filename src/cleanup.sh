#!/bin/sh

for DIR in `cat MANIFEST`; do 
	echo "Cleaning up ${DIR} ..."
	rm -rf ./${DIR}
done

echo "Cleaning up build/*"

rm -rf build/*

rm -f pkginfo
