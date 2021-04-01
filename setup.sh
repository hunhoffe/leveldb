#!/bin/sh

sudo apt update & sudo apt install -y numactl coreutils make gcc git

cd litl
make clean
make
cd ..
make -j 16
