#!/bin/sh
sudo cp bootstrap.pkgs install-root/bootstrap.pkgs
sudo cp bootstrap.sh install-root/bootstrap.sh
sudo chroot install-root "/bootstrap.sh"
