#!/bin/sh

ls -1 *.{gz,xz} \
	| sed -e "s/.gz$//" \
	| sed -e "s/.xz$//" \
	| sed -e "s/.tar$//" \
	> MANIFEST
