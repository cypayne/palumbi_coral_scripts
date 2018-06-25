#!/usr/bin/env python

''' Takes a fasta file of sequences, a COI blast output file,
    and a CR blast output file (sharks), and writes the fasta
    sequences to a new file with new sequence names, in the 
    following format:
        >sequenceID_coi-blast-ID_coi-blast-score_cr-blast-ID_cr-blast-score
    ex. >0557_Alopias_pelagicus_100.000_Carcharhinus_falciformis_100.000

    usage: ./fasta-blast_seq-name-mod.py sequences.fasta coi_blast.out cr_blast.out
    
    CYP 01/25/2018
'''

import sys
import re
from itertools import islice

# initialize data structures
fasta_list = []
coi_list = []
cr_list = []
coi_dict = {}
cr_dict = {}
old2new_name_dict = {}

# regex used to extract sample # from name
samp_num_regex = r"[0-9]{4,5}"


'''
    Used to create dictionary of sample name
    to blast output identity and score combo
'''
def build_blast_dict(lst, dictionary):
  for line in lst:  
    items = line.split("\t")
    sample_name = items[0]
    # collect sample number to put in dictionary
    sample_num = re.findall(samp_num_regex,sample_name)[0]
    # identity is in 3rd item of line, genus is items[3][1]
    # and species name is items[3][2]
    full_id = items[2].split(" ")
    identity = "_".join([full_id[1],full_id[2]])
    score = items[7]
    dictionary[sample_num] = "_".join([identity,score]) 


'''
    Creates dictionary of old sample name : new name
'''
def create_old2new_dict(): 
  # collect all fasta file sample numbers
  with open(fasta_file, 'r') as fasta:
    for count,line in enumerate(fasta, start=0):
      if re.search(">", line): 
        sample_num = re.findall(samp_num_regex,line)[0] 
        fasta_list.append(sample_num)

  # collect coi blast info
  with open(coi_blast_file, 'r') as coi_blast:
    coi_list = coi_blast.readlines()
  # make coi { sample_num : 'identity_score' } dict
  build_blast_dict(coi_list, coi_dict)

  # collect cr blast info
  with open(cr_blast_file, 'r') as cr_blast:
    cr_list = cr_blast.readlines()
  # make cr { sample_num : 'identity_score' } dict
  build_blast_dict(cr_list, cr_dict)

  # finally create dictionary with old_name : new_name conversion
  for fasta_name in fasta_list:
    sample_num = re.findall(samp_num_regex, fasta_name)[0] 
    if sample_num not in cr_dict: cr_name = 'no_CR_data'
    else: cr_name = cr_dict[sample_num]
    # new name is combo of original sample name, coi ID and score, cr ID and score
    new_name = "_".join(['>DCA1',fasta_name,coi_dict[sample_num],cr_name+'\r\n'])
    old2new_name_dict[fasta_name] =  new_name


'''
    Write each sequence with new name to new output file
'''
def generate_outfile(outfile):
  with open(fasta_file) as fin, open(outfile, 'w') as fout:
    while True:
      # collect one seq name, sequence pair at a time to 
      # reduce memory load
      next_seq = list(islice(fin,2))
      if not next_seq: break
      seq_name = next_seq[0] 
      sample_num = re.findall(samp_num_regex,seq_name)[0] 
      next_seq[0] = old2new_name_dict[sample_num]
      fout.writelines(next_seq)


### MAIN ###

'''
    Check that correct number of arguments are passed in
'''
if len(sys.argv) != 4:
  print("Please include one fasta, one coi blast, and one cr blast file.") 
  quit()
else:
  fasta_file = sys.argv[1]
  coi_blast_file = sys.argv[2]
  cr_blast_file = sys.argv[3]
  outfile = "modified_"+fasta_file
 
create_old2new_dict()
generate_outfile(outfile)
print("Awww yeah, your new file is called: " + outfile)
