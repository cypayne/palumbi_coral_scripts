#!/bin/bash
#USAGE: bash batch-hisat2-fq-paired.sh index 4 *_1.txt.gz
#if you don't have a hisat2 index, build it with "bowtie2-build <reference>.fa basename"
# modified from general script, removed -no_splice


CHUNK=$2
COUNTER=0
FQ="${@:3}"
for i in $FQ; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p owners\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=3\n#SBATCH -t 12:00:00\n#SBATCH --mem 24000" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i _1.txt.gz )
    echo "srun hisat2 --end-to-end --very-sensitive -p 3 -X 1500 --rg-id $BASE --rg SM:$BASE -x $1 -1 ${BASE}_1.txt.gz -2 ${BASE}_2.txt.gz > $BASE.sam" >> TEMPBATCH.sbatch
    echo "samtools view -bSq 5 ${BASE}.sam > ${BASE}_BTVS-UNSORTED.bam " >> TEMPBATCH.sbatch
    echo "srun samtools sort ${BASE}_BTVS-UNSORTED.bam ${BASE}" >> TEMPBATCH.sbatch
    #echo "srun samtools index ${BASE}.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}.sam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_BTVS-UNSORTED.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done

if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi 
