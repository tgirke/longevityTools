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
## biocLite("tgirke/longevityTools", build_vignettes=TRUE, dependencies=TRUE) # Installs package from GitHub

## ----documentation, eval=FALSE-------------------------------------------
## library("longevityTools") # Loads the package
## library(help="longevityTools") # Lists package info
## vignette(topic="longevityTools_CMAP", package="longevityTools") # Opens vignette

## ----source_fct, eval=TRUE-----------------------------------------------
fctpath <- system.file("extdata", "analysis_Fct.R", package="longevityTools")
source(fctpath)

## ----download_cmap, eval=FALSE-------------------------------------------
## getCmap(rerun=FALSE) # Downloads cmap rank matrix and compound annotation files
## getCmapCEL(rerun=FALSE) # Download cmap CEL files. Note, this will take some time

## ----get_cel_type, eval=FALSE--------------------------------------------
## celfiles <- list.files("./data/CEL", pattern=".CEL$")
## chiptype <- sapply(celfiles, function(x) affxparser::readCelHeader(paste0("data/CEL/", x))$chiptype)
## saveRDS(chiptype, "./data/chiptype.rds")

## ----normalize_chips, eval=TRUE------------------------------------------
library(BiocParallel); library(BatchJobs); library(affy)
chiptype_list <- split(names(chiptype), as.character(chiptype))
normalizeCel(chiptype_list, rerun=FALSE) # Note: expect in pwd files torque.tmpl and .BatchJobs.R

## ----comb_chip_type_data, eval=TRUE--------------------------------------
chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
combineResults(chiptype_dir, rerun=FALSE)

