#!/bin/bash
HOME=/home/opendev
git clone https://github.com/radareorg/radare2
cd radare2
./sys/user.sh
PATH=$PATH:$HOME/bin
r2pm init
r2pm -ci r2ghidra-dec
