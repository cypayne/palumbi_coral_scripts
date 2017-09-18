#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH -c 4
#SBATCH --mem 24000
#SBATCH -t 6:00:00

#    Merge and sort all bams
#    usage: sbatch ./merge_sort_bams.sh *.bam
#    CYP -- 08/18/2017

samtools merge merged.bam ${@:1}   
samtools sort -o merged-sorted.bam -O bam -T ahya_merged merged.bam 
