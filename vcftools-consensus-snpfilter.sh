#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH -c 4

#usage: sbatch vcftools-consensus-snpfilter.sh combined.vcf
# max-missing 1 = no missing

vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --maf 0.5 --min-alleles 2 --out $(basename $1 .vcf)_maf50
#vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --max-non-ref-af-any 1 --min-alleles 2 --non-ref-af-any 0.5 --out $(basename $1 .vcf)_maf50
#vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --min-alleles 2 --max-alleles 2 --maf 0.5 --out $(basename $1 .vcf)_maf50

# could try --non-ref-af-any : include only sites with all Non-Ref (ALT) allele freqs within the range
