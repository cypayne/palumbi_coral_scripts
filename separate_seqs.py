#!/usr/bin/env python

''' Script to separate all sequences (separated by ">"-lead
     headers) into different files (incrementally numbered)
    usage: ./separate_seqs.py seq_file.fasta
    CYP -- 08/15/2017
'''

import sys
import re

i = 1
first = True
with open(sys.argv[1], 'r') as f:
  for line in f: 
    if re.search(">", line):
      if not first: 
        out.close()
        first = False
      i += 1
      filename = "%s" % line[1:len(line)-1]
      out = open(filename, 'w')
    out.write(line)

out.close()
