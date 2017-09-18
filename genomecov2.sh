#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH -c 4
bedtools genomecov -bga -split -ibam merged-sorted.bam -g $1 

