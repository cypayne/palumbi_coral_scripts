#!/usr/bin/env python

''' Script that extracts consensus 
    scaffolds from consensus output. Meant to
    use output of consensus-contigs.sh as input

    usage: ./pull_scaffolds.py scaffolds.fa output.fa

    NOTE: make sure to change the value of HEADER_REGEX
          to a value that reflects a pattern common to 
          all sequence headers in FASTA file

    CYP 09/12/2017
'''
import re
import sys
from Bio import SeqIO

if len(sys.argv) != 3:
  print("ERROR: Please specify both a scaffolds and an" + \
          "output file name.")
  sys.exit()

fasta_file = sys.argv[1]
out = open(sys.argv[2], 'w')
scaf_name = ''
scaffold = ''

# change these variables as needed
HEADER_REGEX = '@adi'
DEBUG = False 

with open(fasta_file, 'r') as fas:
  for line in fas:
    if re.search(HEADER_REGEX, line):
      skip = False
      scaf_name = line 
      out.write(scaf_name)
    elif re.search(re.escape('+'), line) and not skip:  
      skip = True
      out.write(scaffold)
      scaffold = ''
    elif not skip:
      #line = line.replace('\n','')
      scaffold += line

out.close()
