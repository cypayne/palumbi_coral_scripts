#!/bin/bash
#USAGE: bash batch-bowtie2-softclipping-relaxed.sh b2index 1  *_1.txt.gz
#if you don't have a bowtie2 index, build it with "bowtie2-build <reference>.fa basename"

#Use this script on raw PE sequences (no trim/clip/flash). map qual 10, and deduplicates  

CHUNK=$2
COUNTER=0
FQ="${@:3}"
for i in $FQ; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p owners,spalumbi,normal,hns\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=16\n#SBATCH -t 24:00:00\n#SBATCH --mem 48000" > SOFT-TEMPBATCH.sbatch; fi
    BASE=$( basename $i _1.txt.gz )
    # -p 16, --very-sensitive-local=-D 20 -R 3 -N 0 -L 20 -i S,1,0.5
    #echo "srun bowtie2 --local -D 20 -R 3 -L 3 -N 1 -p 8 -X 1500 --gbar 1 --mp 3 --rg-id $BASE --rg SM:$BASE -x $1 -1 ${BASE}_1.txt.gz -2 ${BASE}_2.txt.gz > $BASE.sam" >> SOFT-TEMPBATCH.sbatch
    echo "srun bowtie2 --very-sensitive-local -p 8 -X 1500 --gbar 1 --mp 3 --rg-id $BASE --rg SM:$BASE -x $1 -1 ${BASE}_1.txt.gz -2 ${BASE}_2.txt.gz > $BASE.sam" >> SOFT-TEMPBATCH.sbatch
    echo "samtools view -bSq 10 ${BASE}.sam > ${BASE}_BTVS-UNSORTED.bam " >> SOFT-TEMPBATCH.sbatch
    echo "srun samtools sort ${BASE}_BTVS-UNSORTED.bam > ${BASE}_UNDEDUP.bam" >> SOFT-TEMPBATCH.sbatch
#    echo "srun java -Xmx4g -jar /share/PI/spalumbi/programs/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=${BASE}_UNDEDUP.bam OUTPUT=${BASE}.bam METRICS_FILE=${BASE}-metrics.txt VALIDATION_STRINGENCY=LENIENT" >> SOFT-TEMPBATCH.sbatch 
    echo "srun samtools index ${BASE}_UNDEDUP.bam" >> SOFT-TEMPBATCH.sbatch
    echo "rm ${BASE}.sam" >> SOFT-TEMPBATCH.sbatch
    echo "rm ${BASE}_BTVS-UNSORTED.bam" >> SOFT-TEMPBATCH.sbatch
    let COUNTER=COUNTER+1
    if [ $COUNTER -eq $CHUNK ]; then
    sbatch SOFT-TEMPBATCH.sbatch
    COUNTER=0; fi
done
if [ $COUNTER -ne 0 ]; then
sbatch SOFT-TEMPBATCH.sbatch; fi 
