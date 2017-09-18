#!/usr/bin/env python

''' Gene Model Extraction from GFF3 file 

    This script extracts gene models from a genome assembly
    by piecing together the exons specified in a predicted 
    gene (GFF3) file. 

    This version is specifically designed to process the 2010
    Acropora digitifera v0.9 genome assembly + GFF3 file available
    through OIST Marine Genomics Unit.

    USAGE: 
      1) to include a GFF3 filtering step:
        ./extract_gene-models.py genome.fasta predicted_genes.gff3
      2) to exclude filtering step, and provide own exonlist.txt file
        ./extract_gene-models.py genome.fasta

    CYP -- 07/25/2017
    
'''

import sys
from subprocess import Popen
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

def prep_GFF3():
  ''' Extracts the lines describing exons in a given GFF3 file
      and writes them to exonlist.txt
  '''
  GFF_file = open(sys.argv[1],'r')
  # filter out all exons, writes to file called exonlist.txt
  Popen("grep 'exon' aug_repeatmask_pasa_input.gff3 \
          | grep -v '#' > exonlist.txt", shell=True)
  GFF_file.close()


def choose_by_length(last_length, prev_length, gm_list):
  ''' For gene models with multiple possible exon combinations, 
      choose the combination by that which has the longest sequence.
      Return: add_seq - True if current sequence is the one to keep, 
                        means to continue adding it
                      - False if should keep previous sequence, 
                        don't add 
  '''

  # if the complete gene model sequence is longer, remove the 
  # previous one from the gene model list, proceed with adding 
  # current gene model sequence
  if prev_length < last_length:
    if prev_length > 0:
      if DEBUG: print("cbl - length of gm list before removal: " \
                        + str(len(gene_models)))
      gene_models.pop() 
      if DEBUG: print("cbl - length of gm list after removal: " \
                        + str(len(gene_models)))
    add_seq = True
  else: add_seq = False
  if DEBUG: print("entered choose_by_length, last-length: " \
                   + str(last_length) + ", prev-length: " \
                   + str(prev_length))
  return add_seq


def choose_by_t1(prev_gene_name, curr_gene_name, gm_list):
  ''' For gene models with multiple possible exon combinations, 
      choose the combination by that which is labelled "t1"
      Return: add_seq - True if current sequence should be kept
                      - False if should keep previous sequence
  '''
  prev = (prev_gene_name.split('.'))[2]
  curr = (gene_name.split('.'))[2]
  if curr == 't1': 
    gene_models.pop()
    add_seq = True
  else: add_seq = False
  return add_seq


def add_record(gene_string, gm_list, gene_name):
  ''' Adds  gene_string sequence to the gene model list
  '''
  if DEBUG: print("ar - length of gm list before append: " \
                    + str(len(gene_models)))
  myseq = SeqRecord(gene_string,id=gene_name)
  gene_models.append(myseq)
  if DEBUG: print("ar - length of gm list after append: " \
                    + str(len(gene_models)))


def approve_add(prev_gene_name, last_gene_name, \
                prev_length, last_length, gene_models):
  ''' Determines whether a sequence should be added to the gene
      model list.
      Returns: add_seq - only False if present gene model's name
                         is the same as the previously added gm 
                         (but with different exon range combo name),
                         and is shorter than the previously added gm
                         otherwise, True
  '''
  add_seq = True
  if prev_gene_name != '' and \
     prev_gene_name.split('.')[1] == (last_gene_name.split('.'))[1]:
    add_seq = choose_by_length(last_length, prev_length, gene_models)
    if DEBUG:
      print("previous gm name: " + prev_gene_name)
      print("last gm name: " + last_gene_name + ", to be added? " \
              + str(add_seq))
  return add_seq

# To print DEBUG statements, change value to True
DEBUG = False 

# create dictionary of genome from genome assembly fasta file
genome_fasta = open(sys.argv[1],'r')
scaffolds_dict = SeqIO.to_dict(SeqIO.parse(genome_fasta, "fasta"))	
genome_fasta.close()

# if GFF3 file is given (last argument), filter it for exons
if len(sys.argv) == 3: prep_GFF3() 

gene_models=[]          # list of complete gene models
last_gene_name = ''     # name of gene for last line's exon
prev_gene_name = ''     # name of gene last added to the gm list
gene_string = ''        # current gm seq, to which exons are appended
last_length = 0         # "last_gene_name" complete seq length
prev_length = 0         # length of previous gene model sequence
line_number = 0         # filtered GFF3 file line counter
first = True            # boolean to indicate if on first exon 

with open("./exonlist.txt", 'r') as f:
  for line in f:
    line_number += 1
    if DEBUG: print("Line number: " + str(line_number)) 
    line = line.strip()
    items = line.split('\t') 

    # collect scaffold name, start & stop bp indices of exon
    scaf_name = items[0]
    start = int(items[3])
    stop = int(items[4])

    # collect unique gene model name
    gene_name_list = items[8].split(';')
    gene_name = str((gene_name_list[1].split('='))[1])

    # if this line has a different gene model name
    # than the last line, and the last gene model
    # should be added, add and reset gene string for 
    # this new gm
    if not first and gene_name != last_gene_name:
      last_length = len(gene_string) 
      add_seq = approve_add(prev_gene_name, last_gene_name, \
                            prev_length, last_length, gene_models)

      # if seq was determined to be added, add to gene model list
      if add_seq:
        add_record(gene_string, gene_models, last_gene_name)
        gene_string = ''
        prev_length = last_length 
        prev_gene_name = last_gene_name

    # append current exon to gene string
    if scaf_name in scaffolds_dict: 
      fasta = scaffolds_dict[scaf_name].seq
      exon = fasta[start:stop]
      gene_string = exon + gene_string
      if DEBUG: print("Scaffold appended")
    else: print("HEY! Scaffold name " + scaf_name \
                  + " wasn't found in the assembly!")

    if first: first = False
    last_gene_name = gene_name

# clear buffer... i.e. add very last sequence
last_length = len(gene_string) 
add_seq = approve_add(prev_gene_name, last_gene_name, \
                      prev_length, last_length, gene_models)

if add_seq:
  add_record(gene_string, gene_models, last_gene_name)

# write all gene models in list to output
SeqIO.write(gene_models, "genemodels.fasta", "fasta")
