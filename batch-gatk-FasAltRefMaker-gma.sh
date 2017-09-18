#!/bin/bash
#usage: bash batch-gatk-FasAltRefMaker-gma.sh ref.fasta outfile_name input.vcf 

REF=$1
OUTFILE=$2
VCF=$3
#java -jar /share/PI/spalumbi/programs/GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -R a_dig_genemodels.fasta -o a_hya_gma_GATK_nosnpmask.fasta [-V combined.vcf or --snpmask combined.vcf]
#java -jar /share/PI/spalumbi/programs/GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -R $REF -o $OUTFILE -V $VCF 


echo -e "#!/bin/bash\n#SBATCH --time=24:00:00 -p spalumbi,owners" > ${OUTFILE}.sbatch
echo "java -jar /share/PI/spalumbi/programs/GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -R $REF -o ${OUTFILE}.fasta -V $VCF" >> ${OUTFILE}.sbatch 

sbatch ${OUTFILE}.sbatch


#for i in $VCFOUT/TEMP-REGIONS* ; do
#    echo sending out batch $i
#    echo -e "#!/bin/bash\n#SBATCH --time=24:00:00 -p spalumbi,owners" > ${i}.sbatch
#    echo "samtools mpileup -l $i -t AD -ugf $REF $BAMS | bcftools call -vmO v  > ${i}.vcf" >> ${i}.sbatch 
#    sbatch ${i}.sbatch
#done
