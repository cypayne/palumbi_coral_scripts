#!/bin/bash
#SBATCH -p owners,spalumbi 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH -t 24:00:00
#SBATCH --mem 48000

# usage: sbatch batch-segemehl-index.sh genome.idx genome.fa

#/scratch/PI/spalumbi/cheyenne/segemehl_0_2_0/segemehl/segemehl.x -x adi_v0.9_genome.idx -d adi_v0.9.scaffold.fa
/scratch/PI/spalumbi/cheyenne/segemehl_0_2_0/segemehl/segemehl.x -x $1 -d $2 
