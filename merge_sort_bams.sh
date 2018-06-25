#!/bin/bash
#SBATCH -p owners,spalumbi,hns,normal
#SBATCH -c 4
#SBATCH --mem 24000
#SBATCH -t 12:00:00

#    Merge and sort all bams
#    usage: sbatch ./merge_sort_bams.sh *.bam
#    CYP -- 08/18/2017

samtools merge merged.bam ${@:1}   

# old version:
#samtools sort merged.bam ahyaHE_on_aten_merged.bam
# new version:
samtools sort -o merged-sorted.bam -O bam -T ahya_on_aten_merged merged.bam 
