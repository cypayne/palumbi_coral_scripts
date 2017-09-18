#!/bin/bash

# Description: 	Sums mapped contig read values from merged_counts.txt and sorts
# 		 genes from smallest to largest sum --> mc_sum-sort.txt
# Note: 	Make sure sum-sort_mergedcounts.py is in same directory
# 		 as this execution script
# Usage: 	./xec_merge-sum-sort.sh merged_counts.sh
# CYP 07/20/17

/scratch/PI/spalumbi/cheyenne/scripts/sum_mergedcounts.py $1
(awk 'NR<2{print $0;next}{print $NF,$0}' ./mc_with-sum.txt | sort -n | cut -f2- -d' ') > mc_sum-sort.txt
