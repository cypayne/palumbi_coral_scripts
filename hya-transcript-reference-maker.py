#!/usr/bin/env python

''' Creates a reference candidate transcripts file [from consensus ahyaALL reads on 
    A. tenuis transcripts]. Includes original sequences, but with sequence names with
    the following format:
      >gene_name, average_coverage, proportion_of_coverage, max_continuous_seq_length,
       apalm_annotation

    usage: ./reference_maker.py reference.fasta avg_coverage.out zero_coverage_summary.out blastn.out apalm_annotations.txt

    CYP 05/08/2018
'''

import sys
from Bio import SeqIO

# make True to change fasta output to csv output
CSV = False

REF_INFILE = sys.argv[1] 
AVG_INFILE = sys.argv[2]
ZERO_INFILE = sys.argv[3]
BLASTN_INFILE = sys.argv[4]
ANNOT_INFILE = sys.argv[5]
if CSV: OUTFILE = './reference.csv'
OUTFILE = './reference.fasta'
hya_annots_dict = {}
max_length_dict = {}

avg_cov_dict = dict(line.strip().split('\t') for line in file(AVG_INFILE))
perc_cov_dict = dict(((line.strip().split('\t'))[0],(line.strip().split('\t'))[3]) for line in file(ZERO_INFILE))
blastn_matches_dict = dict((line.strip().split('\t'))[0:2] for line in file(BLASTN_INFILE))
apalm_annotations_dict = dict((line.strip().split('\t'))[0:3:2] for line in file(ANNOT_INFILE))
# gene_name : SeqRecord of gene seq
record_dict = SeqIO.index(REF_INFILE,'fasta')
 
def annotation():
  for transcript in blastn_matches_dict:
    # get name format of transcript model that will match apalm annotation dict
    apalm_model = '_'.join(blastn_matches_dict[transcript].split('_')[1:])
    if apalm_model in apalm_annotations_dict:
      annotation = apalm_annotations_dict[apalm_model]
      hya_annots_dict[transcript] = annotation
    else:
      hya_annots_dict[transcript] = 'NONE'

def max_cont_length():
  # split sequence by continuous sequence in genes (i.e. without Ns) 
  # in each gene, count lengths of each of these, get max length
  for seq in record_dict:
    # list of seqs separated by at least one N/n
    continuous_seqs = str(record_dict[seq].seq).replace('n','N').split('N')
    # turn into integer lengths
    seq_lengths = list(len(seq) for seq in continuous_seqs)
    # get maximum of lengths and store in lengths dict
    max_length_dict[seq] = max(seq_lengths)

def build_ref():
  with open(OUTFILE,'w') as ref:
    for seq in record_dict:
      try: avg_cover = avg_cov_dict[seq]
      except KeyError: avg_cover = 'NONE'
      try: perc_cover = 1.0-float(perc_cov_dict[seq])
      except KeyError: perc_cover = 1.0
      max_length = max_length_dict[seq]
      try: annotation = hya_annots_dict[seq]
      except KeyError: annotation = 'NONE'
      new_name = ['ahya',seq.split('_')[1]]
      seq_name = '_'.join(new_name)
      header_components = [seq_name, avg_cover, str(perc_cover), str(max_length), annotation]
      header = ', '.join(header_components)
      # write new header and corresponding original seq
      if CSV: ref.write(header+', '+str(record_dict[seq].seq)+'\n')
      else: ref.write('>'+header+'\n'+str(record_dict[seq].seq)+'\n')
    
# MAIN
annotation()
max_cont_length()
build_ref()
