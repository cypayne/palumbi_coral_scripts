#!/bin/bash
#USAGE: bash batch-bowtie2-fq-paired.sh b2index 1  *_1.txt.gz
#if you don't have a bowtie2 index, build it with "bowtie2-build <reference>.fa basename"

#Use this script on raw PE sequences (no trim/clip/flash). This script uses sensitive end to end mapping, map qual 10, and deduplicates  

CHUNK=$2
COUNTER=0
FQ="${@:3}"
for i in $FQ; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p spalumbi,owners,normal,hns\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=16\n#SBATCH -t 28:00:00\n#SBATCH --mem 48000" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i _forward_paired.fq.gz )
    echo "srun bowtie2 --end-to-end -p 16 -X 1500 --rg-id $BASE --rg SM:$BASE --very-sensitive -x $1 -1 ${BASE}_forward_paired.fq.gz -2 ${BASE}_reverse_paired.fq.gz > $BASE.sam" >> TEMPBATCH.sbatch
    echo "samtools view -bSq 10 ${BASE}.sam > ${BASE}_BTVS-UNSORTED.bam " >> TEMPBATCH.sbatch
    echo "srun samtools sort ${BASE}_BTVS-UNSORTED.bam > ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch
    echo "srun java -Xmx4g -jar /share/PI/spalumbi/programs/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=${BASE}_UNDEDUP.bam OUTPUT=${BASE}.bam METRICS_FILE=${BASE}-metrics.txt VALIDATION_STRINGENCY=LENIENT" >> TEMPBATCH.sbatch 
    echo "srun samtools index ${BASE}.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}.sam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_BTVS-UNSORTED.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi 
