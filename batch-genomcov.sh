#!/bin/bash
#usage: bash batch-genomecv.sh merged_bams.bam genome.fasta outfile 
# merged_bams.bam ../../a_digitifera/adig300_0.9gm.fasta genomcov_mergedBams_adigv0.9.txt 
BAMS=$1
GENOME=$2
OUTFILE=$3

echo -e "#!/bin/bash\n#SBATCH --time=24:00:00 -p spalumbi,owners" > ${OUTFILE}.sbatch

echo -e "bedtools genomecov -ibam $BAMS -g $GENOME -d > $OUTFILE" >> ${OUTFILE}.sbatch

sbatch ${OUTFILE}.sbatch
