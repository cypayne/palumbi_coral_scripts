#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH -p spalumbi,owners
#SBATCH --mem 48000  
# usage: sbatch batch-pull_scaffolds.py consensus_scaffolds.fasta output_scafs.fasta

/scratch/PI/spalumbi/cheyenne/scripts/pull_scaffolds.py $1 $2
