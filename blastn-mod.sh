#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH -p spalumbi,hns,normal,owners
#SBATCH --cpus-per-task=12
#SBATCH --mem=64000
#SBATCH --job-name=BLASTN

# modified from kristin's shark blastn script
# sbatch blastn-mod.sh query db 

#blastn -query $1 -db $2 -task blastn -out $3 -outfmt '6 qseqid sseqid stitle bitscore length qstart qend pident qcovs' -gapopen 5 -gapextend 2 -word_size 7 -num_alignments 1 -evalue 0.00001 -num_threads 12
#blastn -query $1 -db $2 -task blastn -out $3 -outfmt 6 -gapopen 5 -gapextend 2 -word_size 7 -evalue 0.0001 -num_threads 12
blastn -query $1 -db $2 -task blastn -out $1.blastn.out -gapopen 5 -gapextend 2 -evalue 0.0001 -max_hsps 1 -max_target_seqs 1 -num_threads 12 -outfmt 6
#blastn -query $1 -db $2 -task blastn -out $1.blastn.out -gapopen 5 -gapextend 2 -evalue 0.001 -num_threads 12 -outfmt 6

