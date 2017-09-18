#!/usr/bin/env python
''' Script to create new list of gene models that do not have missing data (N)
  usage: ./clean_genemodels.py genemodels.fasta
  OUTPUT: clean_genemodels.fasta - contains only gene model sequences with no 
				   missing data
	        gms_with_missing.txt - names of gene models with missing data
	        gms_no_missing.txt - names of gene models with no missing data 

  CYP -- 07/13/2017
'''

import sys
import re 

# To print debugging statements, change DEBUG to True
DEBUG = False

def sort_gms():
  ''' Determines which gene models have and don't have missing data, and writes
      those gene model fasta names to gms_with_missing.txt and gms_no_missing.txt
      respectively. 
  '''
  gm_file = open(sys.argv[1], 'r')
  out_no_missing = open("gms_no_missing.txt",'w')
  out_missing = open("gms_with_missing.txt",'w')
  out_clean = open("clean_genemodels.fasta", 'w')

  reg_gm_name = ">"
  line_count = 0

  first = True
  jump = False

  # loop through each line in file, if you come across a gene model
  # name, then take note of name and start looking for Ns
  for line in gm_file:
    line_count += 1

    # if signaled to move on to next gene model name, and there
    # is no gm name found in current line, skip to next line
    if jump and not re.search(reg_gm_name, line): continue

    if re.search(reg_gm_name, line):    
      # no longer first line, set first bool to false
      if first: first = False
      else:
        # collect gene model name, place in file called gms_no_missing.txt
        if not jump: out_no_missing.write(gm_name)

      # set gm_name to next name
      gm_name = line

      jump = False

    else:
      found = re.search("NNNNNNNNNN", line)

      if found:
        if DEBUG: print("found N on line: %d" % line_count)

        # place the gene model name in a file called gms_with_missing.txt
        out_missing.write(gm_name) 

        # jump to next instance of gene model
        jump = True

      # otherwise move on to next line

  # sort last gene model
  if not jump:
    out_no_missing.write(gm_name)

  if DEBUG: print("Total lines: %d" % line_count)
  gm_file.close()
  out_no_missing.close()
  out_missing.close()


def output_gms():
  ''' Reads every gene model specified in the gms_no_missing.txt from the gene
      model file and writes them to an output file called clean_genemodels.fasta 
  ''' 
  names_file = open("gms_no_missing.txt", 'r')
  out_clean = open("clean_genemodels.fasta", 'w')

  skip_lines = 0
  
  for name in names_file:
    if DEBUG: print("name: " + name)
    found = False
    first = False

    gm_file = open(sys.argv[1], 'r')
    for line in gm_file:
      # find name in total gene models file (genemodels.fasta)
      if re.search(name, line): 
        if DEBUG: print("line: " + line)
        found = True
        first = True
      # if encounter line with the next gene model's name (headed by >), 
      # stop writing to file
      if not first and re.search(">", line): found = False
      if found: out_clean.write(line)
      skip_lines += 1 
      first = False
    
  names_file.close()
  out_clean.close()
  gm_file.close()

def main():
  ''' Runs sorting and output functions to output a file called 
      clean_genemodels.fasta that contains only gene models with no missing data
  '''
  sort_gms()
#  output_gms()

# run main
main()
