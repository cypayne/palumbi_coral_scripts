#!/usr/bin/env python

''' Script that extracts consensus contigs from
    scaffolds with missing data (N/n). Meant to
    use output of consensus-contigs.sh as input

    usage: ./extract_contigs.py scaffolds.fa output.fa

    NOTE: make sure to change the value of HEADER_REGEX
          to a value that reflects a pattern common to 
          all sequence headers in FASTA file

    CYP 08/07/2017
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
HEADER_REGEX = '@Sc'
DEBUG = False 

with open(fasta_file, 'r') as fas:
  for line in fas:
    if re.search(HEADER_REGEX, line):
      skip = False
      scaf_name = line 
    elif re.search(re.escape('+'), line) and not skip:  
      skip = True
      contigs = re.split('NNN|nnn', scaffold) 
      contig_num = 1
      for con in contigs:
        if con != '':
          contig_name = scaf_name + '_' + str(contig_num) + ' <undefined description>'
          out.write(contig_name.replace('\n','') + '\n')
          out.write(con + '\n')
          contig_num += 1
      scaffold = ''
    elif not skip:
      line = line.replace('\n','')
      scaffold += line

out.close()
