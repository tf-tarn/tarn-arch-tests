#!/bin/bash

set -e

mkdir -p testruns

LOGFILE=testruns/testlog.txt

> $LOGFILE
for srcfile in simtests/*.s; do
    echo $srcfile
    name=$(basename $srcfile)
    expectfile=simtests/$name.e
    output=testruns/$name.output
    rm -f $output
    (
        echo
        echo ==== BEGIN TEST $name ====
        set -x
        objfile=testruns/$name.o
        execfile=testruns/$name.out
        memfile=testruns/$name.mem
        tarn-elf32-as -o $objfile $srcfile
        tarn-elf32-ld -T src/ld.txt -o $execfile $objfile
        tarn-elf32-objdump -dw $execfile
        dd if=/dev/zero of=$memfile bs=1024 count=64
        tarn-elf32-run --memory-mapfile $memfile --memory-region 0,65536 --memory-info --map-info -t $execfile
        hexdump -C $memfile | tee $output
    ) >> $LOGFILE 2>&1 || true
    diff -U1 $expectfile $output
done
echo log written to $LOGFILE
