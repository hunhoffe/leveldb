#!/bin/bash
set -ex

benchmark="linux_leveldb.csv"

make clean; make -j8 db_bench
sudo umount /tmp | true
sudo mount -t tmpfs -o size=5G tmpfs /tmp
export LD_PRELOAD=$PWD/libmem.so

reads=100000
nums=50000
val_size=65535
bmark="readrandom"

start=0
end=$(( $1-1))
tput=$(numactl -C $start-$end ./db_bench --benchmarks=fillseq,readrandom --threads=$1 --num=$nums --value_size=$val_size --reads=$reads | grep $bmark)
Ops=$(echo $tput | cut -d';' -f 1 | cut -d',' -f 2 | cut -d ' ' -f 2)

export GIT_REV_CURRENT=`git rev-parse --short HEAD`
echo -e $GIT_REV_CURRENT,$bmark,$1,$reads,$nums,$val_size,$Ops >> $benchmark
