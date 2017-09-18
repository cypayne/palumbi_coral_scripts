#!/bin/bash
# usage: bash batch-clean_gms.sh genemodels.fasta

echo -e "#!/bin/bash\n#SBATCH --time=24:00:00 -p spalumbi,owners" > clean_gms.sbatch

echo -e "./clean_genemodels.py $1" >> clean_gms.sbatch

sbatch clean_gms.sbatch
