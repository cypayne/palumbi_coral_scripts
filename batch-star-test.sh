#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH -t 24:00:00
#SBATCH --mem 48000

/scratch/PI/spalumbi/cheyenne/scripts/STAR/bin/Linux_x86_64_static/STAR --genomeDir /scratch/PI/spalumbi/cheyenne/coral_genome_data/a_digitifera/genome_indices/star --readFilesIn AH06_use.fastq --runThreadN 16
