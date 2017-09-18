#!/usr/bin/env python

''' Outputs all the shark data that matches those in the SHIPPED shark 
    subset

    usage:  ./Vero-sharks_csv-filter.py all_sharks.csv subset_sharks.csv
    output: sharks-filtered.csv shipped-names_not_in_all.csv

    CYP -- 08/03/2017
'''

import sys
import os
import csv

if len(sys.argv) != 3:
  print("Please include 2 csv files") 
  quit()

out_filtered = open("./sharks-filtered.csv", 'w')
out_not_in_ALL = open("./shipped-names_not_in_all.csv", 'w')

subset = []
total = []

# create list of all shark names to filter 
with open(sys.argv[2], 'r') as FILTER:
  for line in FILTER:
    shark_name = ((line.strip()).split(','))[0]
    subset.append(shark_name)

# check which sharks appear in the filter file but
# not the whole sharks file, output to filter file
with open(sys.argv[1], 'r') as ALL:
  for line in ALL:
    shark_name = ((line.strip()).split(','))[0]
    if shark_name in subset:
      out_filtered.write(line)
    total.append(shark_name) 

# if there are any names that appear in the filter
# (SHIPPED) file but not in the total shark sample
# (All) file, output to shipped-names_not_in_all.csv
for name in subset:
  if not name in total:
    out_not_in_ALL.write(name + '\n')

out_filtered.close()
out_not_in_ALL.close()
