#!/usr/bin/env python

'''
    usage: ./swap_IDs.py scaf2acc.txt chr14_scaffolds.txt  
    CYP -- 12/14/2017
'''

import sys
import re

def create_scaf_list():
  # make dictionary out of scaf2acc file, format: {acc# : scaffold_name}
  with open(sys.argv[1], 'r') as a:
    acc_dict = {line.strip().split("\t")[1]:line.strip().split("\t")[0] for line in a}

  # for every line in the input chr14_scaffolds file, record each acc_ID
  # (first column, corresponds to a scaffold_name in acc_dict) in a list
  with open(sys.argv[2], 'r') as b:
    chr14_acc_list = [line.split("\t")[0] for line in b]

  # convert every acc# in chr14_acc_list to a scaffold_name
  chr14_scaf_list = [acc_dict[acc]+"\n" for acc in chr14_acc_list] 
  
  return chr14_scaf_list


''' Function to create file with list of scaffold names on Chrom 14 '''
def chr14_scaf_file(chr14_scaf_list):
  with open("chr14_scaffolds.txt", 'w') as out:
    out.writelines(chr14_scaf_list) 

def make_new_vcf(chr14_scaf_list):
  # for every line in input vcf file, if the scaffold name (first column)
  # matches a name in chr14_scaf_list, write vcf line to new file 
  line_list = []
  with open(sys.argv[3], 'r') as c:
    for line in c:
      items = line.split()
      if items[0] in chr14_scaf_list:
        line_list.append(line)

  with open("chr14_snps.vcf", 'w') as out:
    out.writelines(line_list)
     

### MAIN ###
scaf_list = create_scaf_list()
chr14_scaf_file(scaf_list)
#make_new_vcf(scaf_list)
