#!/bin/bash
# usage: bash batch-clean_gms.sh genemodels.fasta

echo -e "#!/bin/bash\n#SBATCH --time=24:00:00 -p owners --mem 48000" > genotypes.sbatch 

echo -e "bash /scratch/PI/spalumbi/cheyenne/scripts/vcftools-012genotype-matrix.sh $1 $2" >> genotypes.sbatch 

sbatch genotypes.sbatch 

