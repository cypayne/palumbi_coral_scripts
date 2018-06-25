#!/usr/bin/python

# from: https://gif.biotech.iastate.edu/calculate-sequence-lengths-fasta-file
# usage: ./scaf_lengths.py input.fasta

from Bio import SeqIO
import sys
cmdargs = str(sys.argv)
for seq_record in SeqIO.parse(str(sys.argv[1]), "fasta"):
  output_line = '%s\t%i' % \
  (seq_record.id, len(seq_record))
  print(output_line)
