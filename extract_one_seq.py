#!/usr/bin/env python

''' Script to extract one full scaffold, based on scaffold
      number
    usage: ./extract_one_seq.py seq_file.fasta seq_number
    CYP -- 08/16/2017
'''

import sys
import re

seq_number = int(sys.argv[2])
found = False
seq_count = 1
with open(sys.argv[1], 'r') as f:
  for line in f: 
    if re.search(">", line):
      if found: 
        out.close()
        break
      if seq_count == seq_number:
        print("seq_count and seq_number: %d" % seq_count)
        found = True
        filename = "%s_seq%d" % (line[1:len(line)-1], seq_number)
        out = open(filename, 'w')
      else:
        seq_count += 1
    if found: out.write(line)
