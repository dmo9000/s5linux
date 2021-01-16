#!/bin/sh
echo "+++ Creating package datastream ..."
pkgtrans -s `pwd` ${1}.pkg ${1} && sudo rm -rf ${1}
echo "+++ Compressing package datastream ..."
gzip -f -k -9 ${1}.pkg 
