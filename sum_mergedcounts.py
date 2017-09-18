#!/usr/bin/env python

''' Description:	Script that takes a merged-counts.txt file (produced from calling 
    get-bam-counts.sh on .bam files) and 
  		 1) sums all values in each row
  		 2) To also sort by sum from lowest to largest sum value, see usage
  Usage:
 		 1) /PATH/TO/sum_mergedcounts.py merged_counts.txt
 		 2) /PATH/TO/xec_merge-sum-sort.sh merged_counts.txt
  Output: 
 		 1) mc_with-sums.txt 
 		 2) mc_with-sums.txt, mc_sum-sort.txt 
 
  CYP 07/19/2017
'''

import sys

out = open("./mc_with-sum.txt", 'w')
first = True

# key: sum, value: line
sum_dict = {}
with open(sys.argv[1],'r') as f:
  for line in f:
    # skip first line, contains contig names
    if first:
      first = False
      out.write(line)
    else:
      summed = 0
      line = line.strip()
      # vals per line are tab-delimited, separate and store in list
      items = line.split('\t')

      # sum each tab-delimited value in line list (not-including 
      # gene name)
      for val in items[1:]:
        summed += int(val)

      # write full line to output file with the sum of the values
      # appended to the end of the line
      out.write(line + '\t' + str(summed) + '\n')

out.close()

