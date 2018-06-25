#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH -c 4

#usage: sbatch ./genomecov2.sh reference.fasta 

# gives coverage for every single basepair
bedtools genomecov -ibam merged-sorted.bam -g $1 

