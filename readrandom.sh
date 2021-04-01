#!/bin/bash
set -ex

benchmark="linux_leveldb.csv"

make clean; make -j8 db_bench
sudo umount /tmp
sudo mount -t tmpfs -o size=5G tmpfs /tmp
export LD_PRELOAD=$PWD/libmem.so

start=0
end=$(( $1-1))
tput=$(numactl -C $start-$end ./db_bench --benchmarks=fillseq,readrandom --threads=$1 --num=50000 --value_size=65536 --reads=100000 | grep readrandom)
Tput=$(echo $tput | cut -d';' -f 1 | cut -d',' -f 2 | cut -d ' ' -f 2)
echo -e $1, $Tput >> $benchmark
