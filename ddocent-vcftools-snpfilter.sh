#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH -c 4

#usage: sbatch vcftools-consensus-snpfilter.sh combined.vcf

# Filtering step 1
#vcftools --vcf $1 --max-missing 0.5 --mac 3 --minQ 30 --recode --recode-INFO-all --out $(basename $1 .vcf)_filter1
# Filtering step 2
#vcftools --vcf $1 --minDP 3 --recode --recode-INFO-all --out $(basename $1 _filter1.recode.vcf)_filter2
# Filtering step 3
#vcftools --vcf $1 --missing-indv
# Filtering step 4
#vcftools --vcf $1 --remove lowDP.indv --recode --recode-INFO-all --out $(basename $1 _filter2.recode.vcf)_filter4
# Filtering step 5
vcftools --vcf $1 --max-missing 0.95 --maf 0.05 --recode --recode-INFO-all --out $(basename $1 _filter4.recode.vcf)_filter5 --min-meanDP 20

#vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --maf 0.5 --min-alleles 2 --out $(basename $1 .vcf)_maf50
