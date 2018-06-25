#!/bin/bash
#SBATCH -p spalumbi,hns,normal,owners
#SBATCH --time=48:00:00
#SBATCH --mem=200000
#SBATCH -c 4

#    Script to make consensus contig sequences  
#    usage: sbatch ./gatk-consensus.sh reference.fasta sorted.bam output.fq
#    CYP -- 08/21/2017

java -jar /home/groups/spalumbi/programs/GenomeAnalysisTK.jar -R $1 -T HaplotypeCaller -I $2 -o $3
#java -jar /home/groups/spalumbi/programs/GenomeAnalysisTK.jar -R $1 -T FastaAlternateReferenceMaker -o sample.fa --variant sample.vcf

