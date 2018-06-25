#!/usr/bin/env python

''' Summary of zero coverage regions from genomecov output

    usage: ./genomecov_summary.py zerocov_info.out version_# [scaf-lengths.out]
                where zerocov_info.out comes from running:
                  1) sbatch /scratch/PI/spalumbi/cheyenne/scripts/genomecov2.sh
                  2) grep -w 0$ to output
                and version_# is:
                  1 - with zero ranges per scaffold
                  2 - with zero counts, proportions  per scaffold
                and, optionally, scaf-lengths.out is:
                  A tab-delimited file with scaffold_name and scaffold_length
                  created using the scaf_lengths.py script.
                    You can get this using: scaf_lengths.py

    CYP 04/26/2018
'''

import sys

version = sys.argv[2]
scaf2zeros_dict = {}
total_zeros = 0
have_lengths = False

if len(sys.argv) == 4: 
  # if a lengths file is included as an argument, collect lengths per scaf
  have_lengths = True
  length_dict = dict(line.strip().split('\t') for line in file(sys.argv[3]))

with open(sys.argv[1],'r') as infile:
  # create dictionary of ranges with zero coverage per scaffold
  for line in infile:
    zeros_count = -1
    items = line.strip().split('\t')
    zeros_count = int(items[2]) - int(items[1])
    if not items[0] in scaf2zeros_dict:
      scaf2zeros_dict[items[0]] = [zeros_count]
    else:
      scaf2zeros_dict[items[0]].append(zeros_count)

with open('scafs-with-complete-coverage.out','w') as out:
  for scaffold in length_dict:
    if scaffold not in scaf2zeros_dict:
      out.write(scaffold + '\n')
with open('in-gencov-not-in-lengths.out','w') as out:
  for scaffold in scaf2zeros_dict:
    if scaffold not in length_dict:
      out.write(scaffold + '\n')


with open('gencov_zeros_summary.out','w') as outfile:
  for scaffold in scaf2zeros_dict: 
    # if version 1, simply write ranges to outfile
    if version == '1':
      outfile.write(scaffold + ' : ' + scaf2zeros_dict[scaffold])
    # if version 2, write total number of zeros, length, and proportion
    # of zeros for each scaffold to outfile
    if version == '2':
      sum_zeros = 0.0
      for count in scaf2zeros_dict[scaffold]:
        sum_zeros += count
      if have_lengths: 
        # Note: scaffolds with nearly no coverage are ommitted from
        # consensus sequences, so we won't include them in outfile
        if not scaffold in length_dict: action = 0 
          #out = [scaffold, str(sum_zeros), 'NA', 'NA']
          #print(scaffold)
        else: 
          proportion = sum_zeros / float(length_dict[scaffold])
          out = [scaffold, str(sum_zeros), length_dict[scaffold], str(proportion)]
        outfile.write('\t'.join(out) + '\n') 
      else: outfile.write(scaffold + ' : ' + str(sum_zeros) + '\n') 
      total_zeros += sum_zeros 

print('Total zeros:' + str(total_zeros))

