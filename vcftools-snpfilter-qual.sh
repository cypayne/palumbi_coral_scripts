#!/bin/bash
#SBATCH -p owners,spalumbi,hns,normal
#SBATCH -c 4

#usage: sbatch vcftools-snpfilter.sh combined.vcf
# max-missing 1 = no missing

#vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --min-alleles 2 --minQ 20 --minDP 7 --max-missing 0.91 --max-maf 0.95 --maf 0.05 --out $(basename $1 .vcf)_biallelic_minMAF05_GQ20_DP7_maxmissing0.91_nomaxallele
#vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --min-alleles 2 --max-alleles 2 --minQ 20 --minDP 7 --max-missing 1 --max-maf 0.95 --maf 0.05 --out $(basename $1 .vcf)_biallelic_minMAF05_GQ20_DP7_noNA
vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --min-alleles 2 --max-alleles 2 --minQ 20 --minDP 7 --max-missing 0.5 --max-maf 0.95 --maf 0.05 --out $(basename $1 .vcf)_biallelic_minMAF05_GQ20_DP7_noNA_maxmiss0.5
