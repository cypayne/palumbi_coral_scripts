#!/bin/bash
#SBATCH -p owners,spalumbi,hns,normal
#SBATCH --time=48:00:00
#SBATCH -c 4

#    Script to make consensus contig sequences  
#    usage: sbatch ./consensus-contigs.sh reference.fasta sorted.bam output.fq
#    CYP -- 08/21/2017

#samtools mpileup -E -uf $1 $2 | bcftools view -cg - | /scratch/PI/spalumbi/cheyenne/programs/vcfutils.pl vcf2fq > $3
samtools mpileup -uf $1 $2 | bcftools call -c | /scratch/PI/spalumbi/cheyenne/programs/vcfutils.pl vcf2fq -d 1 > $3


#samtools mpileup -uf $1 $2 > mpileup_temp.out 
#bcftools call -c mpileup_temp.out > call_temp.out
#/usr/bin/vcfutils.pl vcf2fq -d 1 call_temp.out > $3
