#!/bin/bash
#USAGE: bash batch-hisat2-fq-single.sh hisat2-index chunksize *.txt.gz
#to build a hisat2 index  "hisat2-build <reference>.fa basename"

#EXAMPLE (from within directory with fastqs): bash batch-bowtie2-fq-single.sh $PI_HOME/ref/ahy_nosym 1 *.txt.gz
CHUNK=$2
COUNTER=0
FQ="${@:3}"
for i in $FQ; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p owners\n#SBATCH --ntasks=1\n#SBATCH -c 3\n#SBATCH -t 12:00:00\n#SBATCH --mem 24000" > TEMPBATCH.sbatch; fi
    #BASE=$(basename $(basename $(basename $( basename $i .gz) .txt) .fq) .fastq)
    BASE=$( basename $i .fastq.gz )
    echo "$BASE"
    #echo "hisat2 --no-unal -p 3 --rg-id $BASE --rg SM:$BASE --very-sensitive -x $1 -U $i > temp$BASE.sam" >> TEMPBATCH.sbatch
    echo "srun hisat2 -p 3 --rg-id $BASE --score-min L,0,-1.2 --rg SM:$BASE -x $1 -U $i > temp$BASE.sam" >> TEMPBATCH.sbatch
    echo "samtools view -bSq 10 temp$BASE.sam > ${BASE}-UNSORTED.bam " >> TEMPBATCH.sbatch
    echo "rm temp$BASE.sam" >> TEMPBATCH.sbatch
    echo "srun samtools sort ${BASE}-UNSORTED.bam > ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch 
    echo "srun java -Xmx4g -jar /share/PI/spalumbi/programs/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=${BASE}_UNDEDUP.bam OUTPUT=${BASE}.bam METRICS_FILE=${BASE}-metrics.txt VALIDATION_STRINGENCY=LENIENT" >> TEMPBATCH.sbatch
    echo "srun samtools index ${BASE}.bam" >> TEMPBATCH.sbatch
    echo "rm ${BASE}-UNSORTED.bam" >> TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch TEMPBATCH.sbatch; fi 
