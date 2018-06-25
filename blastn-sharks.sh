#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH -p owners,normal
#SBATCH --cpus-per-task=12
#SBATCH --mem=64000
#SBATCH --job-name=BLASTCR_nt
# #SBATCH --output=$PI_SCRATCH/cheyenne/sharks/BLASTCR_nt.out
# #SBATCH --error=$PI_SCRATCH/cheyenne/sharks/BLASTCR_nt.err

blastn -query /scratch/PI/spalumbi/cheyenne/sharks/DCA1_Master_42717-shark.fasta -db /scratch/PI/spalumbi/BLAST_db/ncbi_nt_Jan2018/nt -task blastn -out $PI_SCRATCH/cheyenne/sharks/blastn_KR-shark-cr_on_nt.out -outfmt '6 qseqid sseqid stitle bitscore length qstart qend pident qcovs' -gapopen 5 -gapextend 2 -word_size 7 -num_alignments 1 -evalue 0.00001 -num_threads 12
