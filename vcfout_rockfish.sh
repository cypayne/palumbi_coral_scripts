#!/bin/bash
# BEFORE RUNNING: mkdir vcfout (in same directory where data is)
# usage: bash vcfout_rockfish.sh reference.fa vcfout args *.bam > stdout.out
# args are other arguments, for instance "-t DP"

REF=$1
NCPU=$3
VCFOUT=$2
BAMS="${@:4}"
echo $REF
echo $VCFOUT
echo $BAMS

samtools faidx $1
awk '{print $1,"0",$2-1}' ${1}.fai > $VCFOUT/REGIONS.bed
nregions=($(wc -l $VCFOUT/REGIONS.bed))
nlines=$(($nregions /  $NCPU))
echo "Splitting into batches of "$nlines
split $VCFOUT/REGIONS.bed -l $nlines $VCFOUT/TEMP-REGIONS

for i in $VCFOUT/TEMP-REGIONS* ; do
    samtools mpileup -l $i -t AD -ugf $REF $BAMS | bcftools call -vmO v  > ${i}.vcf
done

