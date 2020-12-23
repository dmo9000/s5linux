#!/bin/sh
echo "+++ Creating package datastream ..."
pkgtrans -s `pwd` ${1}.pkg ${1} && sudo rm -rf ${1}
