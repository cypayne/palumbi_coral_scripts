#!/usr/bin/env python

''' Summary of zero coverage regions from genomecov output

    usage: ./avg-cov-gencov-summary.py cov-info.out lengths 
                where cov_info.out comes from running:
                  sbatch /scratch/PI/spalumbi/cheyenne/scripts/genomecov2.sh
                and lengths.out comes from running:
                  ./scaf_lengths.py input.fasta

    CYP 04/26/2018
'''

import sys
import decimal
first = True

scaf2avg_dict = {}

length_dict = dict(line.strip().split('\t') for line in file(sys.argv[2]))

# open coverage file, which has format
#   scaf_name start_bp  end_bp  coverage
with open(sys.argv[1],'r') as infile:
  for line in infile:
    items = line.strip().split('\t')
    length = int(items[2]) - int(items[1])

    coverage = int(decimal.Decimal(items[3]))

    # add a new scaffold entry to dict if not already
    # in dictionary
    if not items[0] in scaf2avg_dict:
      # add the coverage of each bp for this scaffold range
      # entry - i.e. multiply the number of basepairs
      # represented in this range (length) by the coverage
      scaf2avg_dict[items[0]] = [length*coverage]
    else:
      # append to list of range coverages per scaffold
      scaf2avg_dict[items[0]].append(length*coverage)

with open('gencov_avg_summary.out','w') as outfile:
  for scaffold in scaf2avg_dict: 
    sum_cov = 0.0
    # sum all coverage values per scaffold
    for cov in scaf2avg_dict[scaffold]:
      sum_cov += cov
    try: avg = sum_cov / float(length_dict[scaffold])
    except KeyError: avg = 'NONE'
    out = [scaffold, str(avg)]
    # output the average of coverage over all basepairs
    # per scaffold
    outfile.write('\t'.join(out) + '\n') 

