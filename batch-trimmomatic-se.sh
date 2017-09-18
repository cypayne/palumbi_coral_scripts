#!/bin/bash
# usage: bash batch-trimmomatic-se.sh *.fastq.gz
FILES="$@" #"glob" give me all variables

ADAPTERS=$PI_HOME/programs/Trimmomatic-0.35/adapters/TruSeq2-SE.fa
LENGTH=36  #for SE 50bp

#for i in $FILES; do
#  BASE=$(basename $i .fastq.gz)
#  echo -e "#!/bin/bash\n#SBATCH -p owners --mem=8000 --ntasks=1\n" > TEMPBATCH.sbatch
#  echo -e "java -jar $PI_HOME/programs/Trimmomatic-0.35/trimmomatic-0.35.jar SE -phred33 ${BASE}.fastq.gz ${BASE}_trimmed.fastq.gz ILLUMINACLIP:${ADAPTERS}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:${LENGTH}" >> TEMPBATCH.sbatch

#  sbatch TEMPBATCH.sbatch
#done

echo -e "#!/bin/bash\n#SBATCH -p owners --mem=8000 --ntasks=1\n" > TEMPBATCH.sbatch
echo -e "java -jar $PI_HOME/programs/Trimmomatic-0.35/trimmomatic-0.35.jar SE -phred33 $1 ${1}_trimmed.fastq.gz ILLUMINACLIP:${ADAPTERS}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:${LENGTH}" >> TEMPBATCH.sbatch

sbatch TEMPBATCH.sbatch

