#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH -c 4

# NOTE: before running this script, you must do the following:
# 	bgzip filtered_maf50.vcf (gives you filtered_maf50.vcfd.gz)
#	tabix -p vcf filtered_maf50.vcf.gz (gives you filtered_maf50.vcfd.gz.tbi in same directory)

# usage: bcftools consensus infile.fasta output.fasta filtered_maf50.vcf.gz

bcftools consensus -f $1 -o $2 $3

