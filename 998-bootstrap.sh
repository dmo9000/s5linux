#!/bin/sh
sudo cp bootstrap.sh install-root/bootstrap.sh
sudo chroot install-root "/bootstrap.sh"
