#!/usr/bin/env python

''' Script to extract a sub-portion of a sequence in the 
     input file (only pass in base pairs, no headers)
    usage: ./extract_seqs.py seq_file.txt start_bp stop_bp
    CYP -- 07/13/2017
'''

import sys

start = int(sys.argv[2])
stop = int(sys.argv[3])

out = open("extracted_seq.txt", 'w')

with open(sys.argv[1], 'r') as f:
  seq=f.read().replace('\n', '')
  subseq=seq[(start-1):(stop-1)]
  out.write(subseq)

out.close()

