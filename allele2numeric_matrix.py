#!/usr/bin/env python

''' Converts .csv file with genotypes in allele matrix format
    to .csv file with genotypes in 012 matrix format

    usage: ./allele2numeric_matrix.py allele_genos.csv num_info_columns
      - num_info_columns = number of columns with non-genotype
                            information that come before loci
                            columns with genotype info

    CYP 03/05/2018 
'''

import sys
from csv import DictReader 
from csv import writer

# pass in number of info columns before loci (to skip)
NUM_SKIP = int(sys.argv[2])

outfile_name = sys.argv[1].split('.csv')[0] + '_numeric.csv'

with open(sys.argv[1], 'rU') as infile:
  # read the file as a dictionary for each row ({ header : value })
  reader = DictReader(infile)
  fields = reader.fieldnames
  data = {}
  # create a dictionary of lists for each column/loci name 
  # { locus : [snps] }
  row_count = 0
  for row in reader:
    row_count += 1
    for header, value in row.items():
      try:
        data[header].append(value)
      except KeyError:
        data[header] = [value]

  for locus in fields[NUM_SKIP:]:
    homo_one = ''
    first = True
    for i,x in enumerate(data[locus]):
      if x == 'NA': data[locus][i] = 'NA'
      # assign heterozygote genos as 1
      elif not x[0] == x[1]: 
        data[locus][i] = '1'
      elif x[0] == x[1]:
        # assign first homozygous geno as 0
        if first:
          first = False
          homo_one = x
        if x == homo_one: data[locus][i] = '0'
        # assing second homozygous geno as 2
        else: data[locus][i] = '2'
  
# write data dictionary, now in numeric values, to outfile 
with open(outfile_name, 'wb') as outfile:
  writer = writer(outfile, delimiter=',')
  writer.writerow(fields)
  writer.writerows(zip(*[data[key] for key in fields]))
