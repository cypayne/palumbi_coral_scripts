#!/bin/bash
# for paired end, bwa alignment
#USAGE: bash bwa_rockfish_mem-pe-cyp.sh reference.fa chunksize *_1.fa
#if you don't have a bwa index, build it with "bwa index <reference>.fa"
# CYP 08/30/2017

REF=$1
COUNTER=0
FQ="${@:2}"
BASE=$( basename $i _1.fa )
# bwa mem
bwa mem $REF ${BASE}_1.txt.gz ${BASE}_2.txt.gz > ${BASE}.sam
# samtools view
samtools view -bSq 4 ${BASE}.sam > ${BASE}_BTVS-UNSORTED.bam 
# samtools sort
samtools sort ${BASE}_BTVS-UNSORTED.bam > ${BASE}_UNDEDUP.bam
# INCLUDE PATH to picard.jar
java -Xmx4g -jar /opt/picard/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=${BASE}_UNDEDUP.bam OUTPUT=${BASE}.bam METRICS_FILE=${BASE}-metrics.txt VALIDATION_STRINGENCY=LENIENT 
# samtools index
samtools index ${BASE}.bam
rm ${BASE}.sam
rm ${BASE}_BTVS-UNSORTED.bam
rm ${BASE}_UNDEDUP.bam
