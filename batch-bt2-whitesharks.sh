#!/bin/bash

# usage: sbatch batch-bt2-whitesharks.sh bt2index path_to_read_files
'''
#FQ="${@:3}"
# for i in $FQ; do
#XXX for val in OC-116_S12 OC-1_S7 OC-2_S8 OC-3_S9 OC-66_S11 OC-72_S10 WS10-16_S1 WS10-17_S2 WS10-22_S3 WS11-06_S4 WS12-03_S5 WS12-10_S6
#XXX for val in OC-116_S12 OC-1_S7 OC-3_S9 OC-66_S11 OC-72_S10 WS10-16_S1 WS10-17_S2 WS10-22_S3 WS11-06_S4 WS12-03_S5 WS12-10_S6
for val in OC-2_S8 OC-3_S9 OC-66_S11 OC-72_S10 WS10-16_S1 WS10-17_S2 WS10-22_S3 WS11-06_S4 WS12-03_S5 WS12-10_S6
#for val in OC-116_S12 OC-1_S7
do
  fwdlist=""
  revlist=""
  for i in {1..6}
  do
    fwdlist="${fwdlist}${val}_L00${i}_forward_paired.fq.gz"
    revlist="${revlist}${val}_L00${i}_reverse_paired.fq.gz"
    #The if-then command puts commas after every file name 1-5, but not 6
    if [ $i -lt 6 ]
    then
      fwdlist="${fwdlist},"
      revlist="${revlist},"
    fi
  done
  echo -e "#!/bin/bash\n#SBATCH -p spalumbi,owners,normal,hns\n#SBATCH --ntasks=1\n#SBATCH --cpus-per-task=16\n#SBATCH -t 24:00:00\n#SBATCH --mem 48000" > TEMPBATCH.sbatch
  echo "srun bowtie2 -p 16 --end-to-end -x $1 -1 ${fwdlist} -2 ${revlist} | samtools view -b > ${val}_paired_post_trim_to_white_shark.bam" >> TEMPBATCH.sbatch
  sbatch TEMPBATCH.sbatch
done
'''


