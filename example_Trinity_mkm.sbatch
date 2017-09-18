#!/bin/bash 
#################
#set a job name  
#SBATCH --job-name=LOPaired
#################  
#a file for job output, you can check job progress
#SBATCH --output=LOPaired.out
#################
# a file for errors from the job
#SBATCH --error=LOPaired.err
#################
#time you think you need; default is one hour
#in minutes in this case
#SBATCH --time=48:00:00
#################
#quality of service; think of it as job priority
#SBATCH --qos=normal
#################
#memory per node; default is 4000 MB per CPU
# set to >32000MB per CPU (10000*8 = 80000)
#SBATCH --mem=200000
#SBATCH --cpus-per-task=12
#you could use --mem-per-cpu; they mean what we are calling cores
#################
#tasks to run per node; a "task" is usually mapped to a MPI processes.
# for local parallelism (OpenMP or threads), use "--ntasks-per-node=1 --cpus-per-tasks=16" instead
#################
#SBATCH -p hns,spalumbi
#SBATCH --dependency=singleton

/share/PI/spalumbi/programs/trinityrnaseq-2.2.0/Trinity --seqType fq --max_memory 200G --CPU 12 --trimmomatic --single /scratch/PI/spalumbi/cheyenne/transcriptome_refs/new_ahya_transcriptome/RAB_100bp-se/HE/for_transcriptome/AH04.fastq,/scratch/PI/spalumbi/cheyenne/transcriptome_refs/new_ahya_transcriptome/RAB_100bp-se/HE/for_transcriptome/AH64.fastq,/scratch/PI/spalumbi/cheyenne/transcriptome_refs/new_ahya_transcriptome/RAB_100bp-se/HE/for_transcriptome/AH82.fastq 
