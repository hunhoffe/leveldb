#!/bin/bash
make clean; make -j8 db_bench
sudo umount /tmp
sudo mount -t tmpfs -o size=5G tmpfs /tmp
export LD_PRELOAD=$PWD/libmem.so
start=0
end=$(( $1+$start-1))
if [ $"$5" -lt 2 ]
then
  if [ $"${end}" -gt 14 ]
  then
    temp=$(( $end + 14 ))
    end="13,28-${temp}"
  fi
fi

echo $start
echo $end
echo "$start-$end"
numactl -C $start-$end ./db_bench --benchmarks=fillseq,readrandom --threads=$2 --num=$4 --value_size=1024 --reads=$3
