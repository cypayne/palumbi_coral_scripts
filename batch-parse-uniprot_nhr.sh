#!/bin/bash

#This will call the parse-uniprot-xml.py python script for each TEMP_#.fa.blast.out and submit to the cluster

#usage: bash batch-parse-uniprot.sh TEMP*.fa.blast.out

for i in ${@}; do
BASE=$( basename $i .fa.blast.out )
echo -e "#!/bin/bash\necho $BASE\nparse-uniprot-xml_nhr.py ${BASE}_parsed.txt ${i}" > PARSE_${BASE}.sh
sbatch -p spalumbi,owners,hns,normal PARSE_${BASE}.sh
done
