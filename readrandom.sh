#!/bin/bash
make clean; make -j8 db_bench
sudo umount /tmp
sudo mount -t tmpfs -o size=5G tmpfs /tmp
export LD_PRELOAD=$PWD/libmem.so
numactl -C 1-$1 ./db_bench --benchmarks=fillseq,readrandom --threads=$2 --num=1000000 --value_size=1024 --reads=$3
