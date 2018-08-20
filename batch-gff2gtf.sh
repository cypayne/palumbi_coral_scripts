#!/bin/bash
#SBATCH -p spalumbi,owners,normal,hns
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH -t 24:00:00
#SBATCH --mem 48000


# usage: sbatch ./batch-gff2gtf.sh predictions.gff

/scratch/groups/spalumbi/cheyenne/scripts/gff2gtf.py $1

