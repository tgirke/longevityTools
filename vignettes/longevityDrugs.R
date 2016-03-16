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
## library("longevityTools")
## library("ChemmineR")

## ----load_sdf, eval=FALSE------------------------------------------------
## mypath <- system.file("extdata", "longevitydrugs.sdf", package="longevityTools")
## sdfset <- read.SDFset(mypath)
## data(sdfsample)
## sdfsample
## plot(sdfsample[1:4], print=FALSE)

## ----sessionInfo---------------------------------------------------------
sessionInfo()

