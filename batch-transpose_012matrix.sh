#!/bin/bash 

#SBATCH -p owners,hns,normal
#SBATCH --job-name=012trans
#SBATCH --output=012trans.out
#SBATCH --error=012trans.err
#time needed; default is one hour
#in minutes in this case, hh:mm:ss
#SBATCH --time=2:00:00
#memory per node; default is 4000 MB per CPU
#SBATCH --mem=24000

#module load R
Rscript /scratch/PI/spalumbi/cheyenne/scripts/transpose_SNP_matrix.R
