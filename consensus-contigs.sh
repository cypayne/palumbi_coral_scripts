#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH --time=48:00:00
#SBATCH -c 4

#    Script to make consensus contig sequences  
#    usage: sbatch ./consensus-contigs.sh dna.fasta sorted.bam output.fq
#    CYP -- 08/21/2017

samtools mpileup -uf $1 $2 | bcftools call -c | /usr/bin/vcfutils.pl vcf2fq -d 1 > $3

#samtools mpileup -uf $1 $2 > mpileup_temp.out 
#bcftools call -c mpileup_temp.out > call_temp.out
#/usr/bin/vcfutils.pl vcf2fq -d 1 call_temp.out > $3
