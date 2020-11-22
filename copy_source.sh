#!/bin/bash
# $1 should point to .../bespin/target/x86_64-bespin-none/release/build/rkapps-de9d890fa8ca953d/out/leveldb/build
cp -r db/* $1/db
cp -r util/* $1/util
cp -r include/* $1/include
cp -r table/* $1/table
