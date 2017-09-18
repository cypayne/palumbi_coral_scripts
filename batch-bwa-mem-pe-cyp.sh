#!/bin/bash
#USAGE: bash batch-bwa-mem-pe-cyp.sh genome.fa chunk_size *_1.txt.gz
#if you don't have a bwa index, build it with "batch-bwa-index.sh <reference>.fa"
# CYP 08/30/2017

REF=$1
CHUNK=$2
COUNTER=0
FQ="${@:3}"
for i in $FQ; do
    if [ $COUNTER -eq 0 ]; then
    echo -e "#!/bin/bash\n#SBATCH -p owners,spalumbi\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=16\n#SBATCH -t 24:00:00\n#SBATCH --mem 48000" > TEMPBATCH.sbatch; fi
    BASE=$( basename $i _1.txt.gz )
    echo "srun /scratch/PI/spalumbi/cheyenne/bwa-0.7.12/bwa mem $REF ${BASE}_1.txt.gz ${BASE}_2.txt.gz > ${BASE}.sam" >> TEMPBATCH.sbatch
    # -bSq 10
    echo "samtools view -bSq 4 ${BASE}.sam > ${BASE}_BTVS-UNSORTED.bam " >> TEMPBATCH.sbatch
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
