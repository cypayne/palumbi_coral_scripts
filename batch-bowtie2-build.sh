#!/bin/bash
#SBATCH -p owners,spalumbi 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH -t 24:00:00
#SBATCH --mem 200000

/share/PI/spalumbi/programs/bowtie2-build $1 $2
