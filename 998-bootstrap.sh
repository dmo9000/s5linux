#!/bin/sh
sudo cp *.pkgs install-root/packages/
sudo cp bootstrap.sh install-root/bootstrap.sh
sudo chroot install-root /bootstrap.sh /packages/bootstrap.pkgs
