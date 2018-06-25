#!/usr/bin/env python

''' Extracts full sequences corresponding to gene names specified
    in to_extract_list.txt file (one name per line)

    usage: ./match-aten2hya-seqs.py aten-reference.fasta hya-consensus-seqs.fasta

    output: aten2ahya-matches.txt 

    CYP 06/18/2018
'''

import sys
import csv
from Bio import SeqIO

opposite = False

output = "aten_ahya_matches.csv"

# collect ahya seq names in list 
hya_dict = SeqIO.index(sys.argv[2], "fasta")
print("1")
with open(sys.argv[2], 'r') as names:
  names_list = [x.strip() for x in names.readlines()]
print("2")
# make dictionary of reference
ref_dict = SeqIO.index(sys.argv[1], "fasta")
print("3")
with open(output,'wb') as out:
  wrtr = csv.writer(out)
  for seq in hya_dict:
    print(seq)
    outlist = [seq, ref_dict[seq].seq, "hya_"+seq, hya_dict[seq].seq]
    wrtr.writerow(outlist)
    #SeqIO.write(ref_dict[seq],out,"fasta") 
