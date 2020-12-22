#!/bin/bash

mount proc /proc -t proc
mkdir -p /dev/pts
mount devpts /dev/pts -t devpts

cat /etc/motd
echo ""
echo "Welcome to HeadRat Linux!"
echo ""

shopt -s expand_aliases
export BASH_ENV=~/.bashrc

alias ls='ls --color=always'
exec /bin/bash -i 
