#!/bin/bash
#USAGE: bash batch-hisat2-fq-paired.sh index 4 *_1.txt.gz
#if you don't have a hisat2 index, build it with "bowtie2-build <reference>.fa basename"
CHUNK=$2
COUNTER=0
FQ="${@:3}"
for i in $FQ; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p owners,spalumbi\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=3\n#SBATCH -t 12:00:00\n#SBATCH --mem 24000" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i _1.txt.gz )

    #echo "srun hisat2 --end-to-end --very-sensitive --no-spliced-alignment -p 3 -X 1500 --rg-id $BASE --rg SM:$BASE -x $1 -1 ${BASE}_1.txt.gz -2 ${BASE}_2.txt.gz > $BASE.sam" >> TEMPBATCH.sbatch
    # 30% SNPs ~~~> --score-min L,0,-1.8
    # 20% SNPs ~~~> --score-min L,0,-1.2 - use
    # 10% SNPs ~~~> --score-min L,0,-0.6
    #echo "srun hisat2 --end-to-end --no-spliced-alignment -p 3 -X 1500 -k 1 --rg-id $BASE --rg SM:$BASE --score-min L,0,-1.2 -x $1 -1 ${BASE}_1.txt.gz -2 ${BASE}_2.txt.gz > ${BASE}_all.sam" >> TEMPBATCH.sbatch
    echo "srun hisat2 --end-to-end --no-spliced-alignment -p 3 -X 1500 --rg-id $BASE --rg SM:$BASE --score-min L,0,-1.2 -x $1 -1 ${BASE}_1.txt.gz -2 ${BASE}_2.txt.gz > ${BASE}_all.sam" >> TEMPBATCH.sbatch

    ## need to filter SAM file by NH:i:1 in order to get bam files that only contain reads that aligned once (uniquely)
    echo "grep -P '^@|NH:i:1\b' ${BASE}_all.sam > ${BASE}.sam" >> TEMPBATCH.sbatch
    echo "samtools view -bSq 4 ${BASE}.sam > ${BASE}_BTVS-UNSORTED.bam " >> TEMPBATCH.sbatch
    echo "srun samtools sort ${BASE}_BTVS-UNSORTED.bam > ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch
    echo "srun java -Xmx4g -jar /share/PI/spalumbi/programs/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=${BASE}_UNDEDUP.bam OUTPUT=${BASE}.bam METRICS_FILE=${BASE}-metrics.txt VALIDATION_STRINGENCY=LENIENT" >> TEMPBATCH.sbatch 
    echo "srun samtools index ${BASE}.bam" >> TEMPBATCH.sbatch
    #echo "rm ${BASE}.sam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_BTVS-UNSORTED.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi
