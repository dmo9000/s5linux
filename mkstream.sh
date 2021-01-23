#!/bin/sh
set -e
PATH=$PATH:/usr/ccs/bin:/usr/5bin
echo "+++ Creating package datastream ..."
pkgtrans -s `pwd` ${1}.pkg ${1} && sudo rm -rf ${1}
echo "+++ Compressing package datastream ..."
gzip -f -k -9 ${1}.pkg 
if [ -r ${1}.pkg ] ; then 
	rm -f ${1}.pkg
fi
