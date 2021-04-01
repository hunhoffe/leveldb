#!/bin/bash

sudo apt update & sudo apt install -y numactl coreutils make gcc git

cd litl
make clean
make
cd ..

benchmark="linux_leveldb.csv"
rm -f $benchmark
echo "git_rev,benchmark,ncores,reads,num,val_size,operations" > $benchmark

MAXCORES=$(nproc)

if [[ $MAXCORES -eq 192 ]]; then
	 MAXCORES=96
	 increment=8
	 nodes=4
elif [[ $MAXCORES -eq 56 ]]; then
	MAXCORES=28
	increment=4
	nodes=2
elif [[ $MAXCORES -eq 64 ]]; then
	MAXCORES=32
	increment=4
	nodes=2
else
	increment=2
	nodes=1
fi

for core in `seq 0 $increment $MAXCORES`; do
	if [[ $core -eq 0 ]] || [[ $core -eq 1 ]]
	then
		core=1
	fi
	bash readrandom.sh $core
done
sudo umount /tmp
