#!/usr/bin/env python 

''' Extracts full sequences corresponding to gene names specified
    in to_extract_list.txt file (one name per line)

    usage: ./extract_contigs_seqio-fast.py reference.fasta to_extract_list.txt

    output: extracted_seqs.fasta - desired sequences in fasta format
    CYP 05/12/2018
'''

import sys
from Bio import SeqIO

# if you want to keep everything but the seqs
# in the extract list instead, set to True
opposite = False

if opposite: outfile = 'good_seqs.fasta'
else: outfile = 'extracted_seqs.fasta'
# collect seq names in list 
with open(sys.argv[2], 'r') as names:
  names_list = [x.strip() for x in names.readlines()]

# make dictionary of reference
ref_dict = SeqIO.index(sys.argv[1], "fasta")
if opposite:
  with open(outfile,'w') as out:
    for seq in ref_dict:
      if not seq in names_list:
        SeqIO.write(ref_dict[seq],out,"fasta") 
else: 
  with open(outfile, 'w') as out:
    for seq in names_list: 
      seq = seq+","
      SeqIO.write(ref_dict[seq],out,"fasta") 
