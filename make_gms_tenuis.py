#!/usr/bin/env python
'''
script to subset A. tenuis genome into gene model seqs specified in GFF file
tab-delimited lists of genes and other information, in GFF Format:

## GFF format:
##	1:	sequencename (in our case, CHROM or contig name)
##	2:	source (maker or .)
##	3:	feature
##	4:	start base
##	5:	end base
##	6:	score
##	7:	strand (+/-)
##	8:	frame (0,1, or 2.... 0 means first base of feature is first base of codon)
##	9:	attribute
##	10:

usage (normal):   ./make_gene_models.py GFF_file genome_fasta
usage (debug):   ./make_gene_models.py GFF_file genome_fasta output.txt 

## NOTES: run through Palumbi lab anaconda version of python

cyp 03/19/2018
'''

import sys
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import IUPAC

if len(sys.argv) == 4:
  DEBUG = True
elif len(sys.argv) == 3:
  DEBUG = False
else:
  print("Please provide 3-4 arguments, specified in header of script")
  exit()


GFF_file = open(sys.argv[1],'r')
genome_fasta = open(sys.argv[2],'r')
if DEBUG: out = open(sys.argv[3],'w')

# create dictionary of genome from fasta file
scaffolds_dict = SeqIO.to_dict(SeqIO.parse(genome_fasta, "fasta"))	
genome_fasta.close()

gene_models=[]
total_scaffolds = 0
total_matches = 0
for line in GFF_file:
	total_scaffolds += 1
	line = line.strip()
	items = line.split('\t')
	# (gene_CHROM) format of A_gem genome fasta: adi_Scaffold#, format of gff gene IDs: scaf#
	# will need to convert searched name
	gene_CHROM = items[0]
	#gff_seq_name = items[0]
	#gene_CHROM = 'adi_Scaffold' + gff_seq_name[4:] 
	#if(gene_CHROM[12:] != gff_seq_name[4:]):
	#	print('HOLD UP')

	gene_start = int(items[3])	# tab 4 (items[3]) = start base, tab 5 (items[4]) = end base
	gene_end = int(items[4])
	gene_name_list = items[8].split(';')
	gene_name_info = gene_name_list[0].split('=')
	gene_name = str(gene_name_info[1])
	
	if gene_CHROM in scaffolds_dict:
		total_matches += 1
		fasta = scaffolds_dict[gene_CHROM].seq
		newseq = fasta[(gene_start-1):(gene_end+300)] # add 300 bp 3' of the stop codon (end) 
		myseq = SeqRecord(newseq,id=gene_name)
		#out.write("gene_CHROM, gene_name: ")
		#out.write(gene_CHROM)		
		#out.write(gene_name + '\n')		
		gene_models.append(myseq)

	# for debugging
	#else:
		#write all the scaffold names that didn't match to the output file	
		#out.write(gene_CHROM + '\n')		
	#	print("gene_CHROM: ")
	#	print(gene_CHROM)
	#	print("gene_name: ")
	#	print(gene_name)
	#	print("\n")

#SeqIO.write(gene_models, "genemodels_test.fasta", "fasta")
SeqIO.write(gene_models, "genemodels.fasta", "fasta")

print("total gff scaffolds: " + str(total_scaffolds))
print("total matches: " + str(total_matches))
GFF_file.close()
#out.close()
