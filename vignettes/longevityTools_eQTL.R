## ----style, echo = FALSE, results = 'asis'-------------------------------
BiocStyle::markdown()
options(width=100, max.print=1000)
knitr::opts_chunk$set(
    eval=as.logical(Sys.getenv("KNITR_EVAL", "TRUE")),
    cache=as.logical(Sys.getenv("KNITR_CACHE", "TRUE")))

## ----setup, echo=FALSE, messages=FALSE, warnings=FALSE-------------------
suppressPackageStartupMessages({
    library(longevityTools) 
    library(ggplot2) }) 

## ----install, eval=FALSE-------------------------------------------------
## source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script
## biocLite("tgirke/longevityTools", build_vignettes=FALSE) # Installs package from GitHub

## ----documentation, eval=FALSE-------------------------------------------
## library("longevityTools") # Loads the package
## library(help="longevityTools") # Lists package info
## vignette("longevityTools") # Opens vignette

## ----source_fct, eval=TRUE-----------------------------------------------
fctpath <- system.file("extdata", "longevityTools_eQTL_Fct.R", package="longevityTools")
source(fctpath)

## ----work_envir, eval=FALSE----------------------------------------------
## dir.create("data"); dir.create("results")

## ----eQTL_download, eval=FALSE-------------------------------------------
## download.file("http://www.gtexportal.org/static/datasets/gtex_analysis_v6/single_tissue_eqtl_data/GTEx_Analysis_V6_eQTLs.tar.gz", "./GTEx_Analysis_V6_eQTLs.tar.gz")
## untar("GTEx_Analysis_V6_eQTLs.tar.gz")

## ----geneGrep, eval=TRUE-------------------------------------------------
library(longevityTools)
samplepath <- system.file("extdata", "Thyroid_Analysis.snpgenes.TXNRD2", package="longevityTools") 
dat <- read.delim(samplepath)
myGenes <- c("TXNRD2")
result <- geneGrep(dat, myGenes)
head(result[order(result$p_value),])
#output results in PLINK format
result2<-result[,c("snp_id_1kg_project_phaseI_v3","p_value")]
names(result2)<-c("SNP","P")
#write.table(result2,file="data/eSNP.assoc",quote=F,row.names=F)


## ----1KG_download_filter, eval=FALSE-------------------------------------
## #genotypes
## download.file("ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz", "./ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz")
## untar("ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz")
## 
## #sample ped file
## download.file("ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v2.20130502.ALL.ped", "./integrated_call_samples_v2.20130502.ALL.ped")
## 
## #sample super population file
## download.file("ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel", "./integrated_call_samples_v3.20130502.ALL.panel")
## 
## #identify EUR unrelated samples from 1KG phase 3
## ped2<-read.table("data/integrated_call_samples_v2.20130502.ALL.ped", stringsAsFactors = F, header = T, sep="\t")
## ped3<-read.table("data/integrated_call_samples_v3.20130502.ALL.panel", stringsAsFactors = F, header = T, sep="\t")
## 
## samples1KG <- filter_1KGsamples("EUR",ped2,ped3)
## samples1KG_ID <- samples1KG[,"Individual.ID",drop=F]
## write.table(samples1KG_ID,file="data/samples1KG.txt",quote=F,row.names=F,col.names=F)
## 

## ----regionsFile, eval=FALSE---------------------------------------------
## regions<-data.frame(chr="chr1",pos=0,pos_to=0,stringsAsFactors = F)
## regions$chr[1]<-gsub("chr","",result$snp_chrom[1]) #1KG genotype files do not have chr
## regions$pos[1]<-min(result$snp_pos)
## regions$pos_to[1]<-max(result$snp_pos)
## write.table(regions,file="data/regions.txt",quote=F,row.names=F,col.names=F,sep="\t")

## ----sessionInfo---------------------------------------------------------
sessionInfo()

