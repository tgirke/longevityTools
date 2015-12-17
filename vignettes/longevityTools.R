## ----style, echo = FALSE, results = 'asis'-------------------------------
BiocStyle::markdown()
options(width=100, max.print=1000)
knitr::opts_chunk$set(
    eval=as.logical(Sys.getenv("KNITR_EVAL", "TRUE")),
    cache=as.logical(Sys.getenv("KNITR_CACHE", "TRUE")))

## ----setup, echo=FALSE, messages=FALSE, warnings=FALSE-------------------
suppressPackageStartupMessages({
    library(longevityTools)
    library(ggplot2)
})

## ----install, eval=FALSE-------------------------------------------------
## source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script
## biocLite("tgirke/longevityTools", build_vignettes=TRUE, dependencies=TRUE) # Installs package from GitHub

## ----documentation, eval=FALSE-------------------------------------------
## library("longevityTools") # Loads the package
## library(help="longevityTools") # Lists package info
## vignette("longevityTools") # Opens vignette

## ----eQTL_download, eval=FALSE-------------------------------------------
## download.file("http://www.gtexportal.org/static/datasets/gtex_analysis_v6/single_tissue_eqtl_data/GTEx_Analysis_V6_eQTLs.tar.gz", "./GTEx_Analysis_V6_eQTLs.tar.gz")
## untar("GTEx_Analysis_V6_eQTLs.tar.gz")

## ----geneGrep, eval=TRUE-------------------------------------------------
library(longevityTools)
samplepath <- system.file("extdata", "Whole_Blood_Analysis.snpgenes.head100", package="longevityTools") 
dat <- read.delim(samplepath)
myGenes <- c("RP11-693J15.4", "RP11-809N8.4", "junkNoMatch")
result <- geneGrep(dat, myGenes)
result

## ----sessionInfo---------------------------------------------------------
sessionInfo()

