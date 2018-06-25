#!/bin/bash 
#SBATCH -p owners,spalumbi,normal,gpu
#SBATCH --time=48:00:00
#SBATCH --mem=32000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
########################
# -outfmt 5
# to call: sbatch blastp-uniprot_nhr.sh input.fa

#this echoes your TEMP file name to the slurm output in case any files are aborted on owners nodes or have errors
echo $1

#blast against uniprot_db

blastp -db /scratch/PI/spalumbi/uniprot-db/uni-swissprot_db -query $1 -out $1.blast.out -evalue 0.001 -max_target_seqs 1 -num_threads 6 -outfmt 5

