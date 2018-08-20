#!/usr/bin/env python

''' Checks that every row in gff3 file has only
    9 tab-delimited fields - if there are more than
    9, the row is rewritten so that the last x number
    of fields are combined

    usage: ./gff3-fix.py predictions.gff 

    output: predictions_new.gff - new gff file 
    CYP 08/20/2018
'''

import sys
import csv
import re

new_rows = []
outfile = sys.argv[1].split('.gff')[0]+'_new.gff'

with open(sys.argv[1],'rb') as gff:
  rdr = csv.reader(gff,delimiter='\t')
  for row in rdr:
    if re.search("ScRDnwc",row[0]):
      if len(row) > 9:
        new = row[0:8]
        new.append(' '.join(row[8:]))
      else:
        new = row
    else: new = row
    new_rows.append(new)

with open(outfile,'w') as out:
  wrtr = csv.writer(out,delimiter='\t')
  wrtr.writerows(new_rows)
