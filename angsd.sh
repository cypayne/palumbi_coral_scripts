#!/bin/bash
# usage: bash ansd.sh bam.filelist

BAMLIST=$1
echo -e "#!/bin/bash\n#SBATCH --cpus-per-task=12 --time=24:00:00 -p spalumbi,owners" > angsd.sbatch
echo "angsd -GL 1 -out genolike -nThreads 12 -doGlf 2 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-6 -doMaf 1 -bam $BAMLIST" >> angsd.sbatch

