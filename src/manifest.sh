#!/bin/sh

ls -1 *.{gz,xz,bz2,tar} \
	| sed -e "s/.gz$//" \
	| sed -e "s/.xz$//" \
	| sed -e "s/.tar$//" \
	| sed -e "s/.bz2$//" \
	| uniq \
	> MANIFEST

sed -i "s/\.tar$//" MANIFEST
