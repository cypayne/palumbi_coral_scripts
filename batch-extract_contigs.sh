#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH -p spalumbi,owners
#SBATCH --mem 48000  
# usage: sbatch batch-extract_contigs.sh consensus_scaffolds.fasta output_contigs.fasta

/scratch/PI/spalumbi/cheyenne/scripts/extract_contigs.py $1 $2
