#!/bin/bash
#SBATCH -p owners,spalumbi 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH -t 24:00:00
#SBATCH --mem 48000

# usage: sbatch batch-bwa-index.sh genome.fa
 
/scratch/PI/spalumbi/cheyenne/bwa-0.7.12/bwa index $1
