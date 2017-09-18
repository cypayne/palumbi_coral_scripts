#!/bin/bash

FQ="${@:1}"
for i in $FQ; do
  BASE=$( basename $i .fastq )
  #last_line="$(tac ${BASE}.fastq | egrep -m 1 .)" 
  last_line="$(tail -n 1 ${BASE}.fastq)"
  if [ "$last_line" == "@HWI" ]; then
    echo "$i has @HWI last line"
    head -n -1 ${BASE}.fastq > ${BASE}_use.fastq
    mv ${BASE}.fastq ${BASE}_original.fastq; fi
done

