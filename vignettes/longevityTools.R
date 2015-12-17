## ----style, echo = FALSE, results = 'asis'-------------------------------
BiocStyle::markdown()
options(width=100, max.print=1000)
knitr::opts_chunk$set(
    eval=as.logical(Sys.getenv("KNITR_EVAL", "TRUE")),
    cache=as.logical(Sys.getenv("KNITR_CACHE", "TRUE")))

## ----setup, echo=FALSE, messages=FALSE, warnings=FALSE-------------------
suppressPackageStartupMessages({
    library(longevityTools) library(ggplot2) }) ```

Note: the GitHub repository of this package is [here](https://github.com/tgirke/longevityTools) and teh most recent version of this tutorial can be found [here](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools.html).

# Introduction text text text text text text text text text text text text
text text text text text text text text text text text text
text text text text text text text text text text text text
text text text text text text text text text text text text
some citation [@Li2013-oy; @Li2009-oc]

<div align="right">[Back to Table of Contents]()</div>


# Getting Started

## Installation

The R software for running [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


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

