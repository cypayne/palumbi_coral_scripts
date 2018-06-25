#!/bin/bash
echo -e "#!/bin/bash\n#SBATCH -p owners,spalumbi\n#SBATCH --ntasks=1\n#SBATCH -c 3\n#SBATCH -t 24:00:00\n#SBATCH --mem 48000" > TEMPBATCH.sbatch;
BASE=$2
echo "samtools view -bSq 10 temp$BASE.sam > ${BASE}-UNSORTED.bam " >> TEMPBATCH.sbatch
#echo "rm temp$BASE.sam" >> TEMPBATCH.sbatch
echo "srun samtools sort ${BASE}-UNSORTED.bam > ${BASE}_UNDEDUP.bam" >> TEMPBATCH.sbatch 
echo "srun java -Xmx4g -jar /share/PI/spalumbi/programs/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=${BASE}_UNDEDUP.bam OUTPUT=${BASE}.bam METRICS_FILE=${BASE}-metrics.txt VALIDATION_STRINGENCY=LENIENT" >> TEMPBATCH.sbatch
echo "srun samtools index ${BASE}.bam" >> TEMPBATCH.sbatch
echo "rm ${BASE}-UNSORTED.bam" >> TEMPBATCH.sbatch

sbatch TEMPBATCH.sbatch;
