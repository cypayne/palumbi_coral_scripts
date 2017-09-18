#!/bin/bash
#SBATCH -p owners,spalumbi 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH -t 24:00:00
#SBATCH --mem 48000
# usage: sbatch star-build.sh genomeDir genomeFastaFile 

/scratch/PI/spalumbi/cheyenne/scripts/STAR/bin/Linux_x86_64/STAR --runMode genomeGenerate --genomeDir $1 --genomeFastaFiles $2 --runThreadN 16
