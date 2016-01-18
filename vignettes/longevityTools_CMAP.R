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
## vignette("longevityTools_CMAP", package="longevityTools") # Opens vignette

## ----source_fct, eval=TRUE-----------------------------------------------
fctpath <- system.file("extdata", "analysis_Fct.R", package="longevityTools")
source(fctpath)

## ----download_cmap, eval=TRUE--------------------------------------------
getCmap(rerun=FALSE) # Downloads cmap rank matrix and compound annotation files
getCmapCEL(rerun=FALSE) # Download cmap CEL files. Note, this will take some time

## ----sessionInfo---------------------------------------------------------
sessionInfo()

