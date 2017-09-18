# script modified from BETHSHEETS Pop-Genomics-via-RNAseq / R-scripts / SNPrelate_sample.R
# follows framework on guide-to-R-scripts page, SNP ANALYSIS
# Cheyenne Payne, 06/27/2017

library(data.table)

#make a matrix of your 012 SNP data
#first column holds index, not genotype info, also there is no header

# SET PATH
snps<-read.delim('/Users/cheyennepayne/palumbi/a_gem_012gen.012',header=F)
pos<-read.delim('/Users/cheyennepayne/palumbi/a_gem_012gen.012.pos',header=F)
indv<-read.delim('/Users/cheyennepayne/palumbi/a_gem_012gen.012.indv',header=F)

colnames(snps)<-paste(pos[,1],pos[,2],step='-')
rownames(snps)<-indv[,1]
snps<-as.matrix(snps)

#PCA of SNPs
pc.out<-prcomp(snps)
summary(pc.out)
plot(pc.out$x[,1],pc.out$x[,2])	#PC1 v PC2
