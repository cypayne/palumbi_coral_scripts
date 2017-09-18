#!/usr/bin/env python

''' Finds the contig matches unique to one blast output
    vs another

    usage:  ./get_unique_blasts.py file1.blast.out file2.blast.out
    output: unique_to_file1.out & shared.out

    CYP -- 07/28/2017
'''

import sys
import os

if len(sys.argv) != 3:
  print("Please include 2 blast.out files: \
          ./get_unique_blasts.py file1.blast.out file2.blast.out") 
  quit()

unique_outfile = "./unique_to_" + os.path.splitext(sys.argv[1])[0] + ".out"
out_unique = open(unique_outfile, 'w')
out_shared = open("./shared.out", 'w')

second_contigs = []
# create list of all the second file's contig names
with open(sys.argv[2], 'r') as SECOND:
  for line in SECOND:
    contig_name2 = ((line.strip()).split('\t'))[0]
    second_contigs.append(contig_name2)

# check which contigs appear in the first file but
# not the second
with open(sys.argv[1], 'r') as FIRST:
  for line in FIRST:
    contig_name1 = ((line.strip()).split('\t'))[0]
    if not contig_name1 in second_contigs:
      out_unique.write(line)
    else:
      out_shared.write(line) 

out_unique.close()
out_shared.close()
