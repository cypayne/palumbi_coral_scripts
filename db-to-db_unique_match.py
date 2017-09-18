#!/usr/bin/env python

''' Counts the number of query read matches in a blast output file
    (format 6) that are unique to some other database
    For example: 
        1) Have created a database for each of two reference protein 
           genomes
        2) Have a denovo transcriptome assembly that you have run 
           blastx on for each database to find good contigs
        3) Have called get_unique_blasts.py on each blastx output to
           get the contig matches that are unique to each database
        4) Have made database for a contaminant potentially in denovo
           transcriptome and blastx transcriptome on contaminant db
        5) NOW want to know how many of the assembly-to-contaminant 
           contig matches were unique to either of the reference protein 
           genomes

    usage:  ./db-to-db_unique_match.py query-to-db.blast.out unique_to_some-db.out  
    output: count.out

    CYP -- 08/02/2017
'''

import sys
import os

if len(sys.argv) != 3:
  print("Please include 1 blast.out file and 1 unique reads file: \
         ./db-to-db_unique_match.py query-to-db.blast.out unique_to_some-db.out")  
  quit()

unique_count = 0      # counts number of matches unique to db
not_unique_count = 0  # counts number of contigs that aren't unique to db
unique_contigs = []

# create list of all the second file's contig names
with open(sys.argv[2], 'r') as UNIQUE:
  for line in UNIQUE:
    contig_name = ((line.strip()).split('\t'))[0]
    unique_contigs.append(contig_name)

# check which contigs appear in the first file but
# not the second
with open(sys.argv[1], 'r') as BLAST:
  for line in BLAST:
    contig_name = ((line.strip()).split('\t'))[0]
    if contig_name in unique_contigs:
      unique_count += 1
    else:
      not_unique_count += 1

# print results to STDOUT
print("# contig matches that are unique to this db: " + str(unique_count))
print("# contig matches that aren't unique to this db: " + str(not_unique_count))
