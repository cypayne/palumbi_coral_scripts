#!/bin/bash
#SBATCH -p spalumbi,hns,normal,owners 
#SBATCH --time=48:00:00
#SBATCH --mem=32000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
########################
# -outfmt 6 XML

# Query: translated nucleotide, DB: translated nucleotide 

# note: -max_hsps 1 : gives only the top match so that only unique query-db matches are in output

tblastx -query $1 -db $2 -out $1.blast.out -evalue 0.0001 -max_hsps 1 -max_target_seqs 1 -num_threads 12 -outfmt 6
