#!/bin/bash
# Script for removing .sam, .bam, .bam.bai, slurm, and TEMPBATCH
# outputs that result from mapping that you don't want
# usage: alias made in .bashrc file called "mapclean"
#	 bash ./clean_map_outs.sh

rm *.sam
rm *.bam
rm *.bam.bai
rm *.txt
rm slurm-*
rm TEMPBATCH*

