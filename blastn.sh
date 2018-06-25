#!/bin/bash
#SBATCH -p owners,normal,hns 
#SBATCH --time=48:00:00
#SBATCH --mem=32000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
########################
# -outfmt 5 XML
# to call: sbatch blastn.sh db_path query.fa 

# note: -max_hsps 1 : gives only the top match so that only unique query-db matches are in output

#blastn -db $1 -query $2 -out $1.blast.out -evalue 0.001 -max_hsps 1 -max_target_seqs 1 -num_threads 12 -outfmt 6
blastn -db $1 -query $2 -out $1.blast.out -evalue 0.01 -num_threads 12 -outfmt 6

