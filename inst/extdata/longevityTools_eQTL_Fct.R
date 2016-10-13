#######################################################################
## Functions that are in early development for eQTL analysis project ##
#######################################################################
## Author: Dan Evans
## Last update: 2016-10-13

#function to mark SNPs where the coded alleles from the study data must be switched to match the effect alleles reported from previous GWAS
alleleCheck <- function(mydat){
  #GWAS alleles are effect_allele and non_effect_allele
  #Cohort alleles are coded_all and noncoded_all
  mydat[ ,effect_allele:=toupper(effect_allele ) ]
  mydat[ ,non_effect_allele:=toupper(non_effect_allele) ]
  mydat[ ,coded_all:=toupper(coded_all) ]
  mydat[ ,noncoded_all:=toupper(noncoded_all) ]
  
  #test for same alleles 
  mydat[,noMatch:=0]
  mydat[effect_allele!=coded_all | non_effect_allele!=noncoded_all , noMatch:=1]
  
  #test if switching coding and non-coding alleles solves non-matching.
  mydat[ , allele_switch:=0]
  mydat[noMatch==1 & effect_allele==noncoded_all & non_effect_allele==coded_all, allele_switch:=1  ]
  return(mydat[noMatch==1 & allele_switch==0, .N ])
}


