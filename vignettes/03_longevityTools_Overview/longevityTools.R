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
## biocLite("tgirke/longevityTools", build_vignettes=FALSE, dependencies=FALSE) # Installs package from GitHub

## ----documentation, eval=FALSE-------------------------------------------
## library("longevityTools") # Loads the package
## library(help="longevityTools") # Lists package info
## vignette("longevityTools") # Opens vignette

## ----github_usage, eval=FALSE, engine="sh"-------------------------------
## git clone git@github.com:tgirke/longevityTools.git
## cd longevityTools
## git pull # Get updates from remote
## git branch # Check whether you are in the master branch
## ## do some work, commit/push changes to local and remote ##
## git commit -am "some edits"; git push -u origin master

## ----package_build, eval=FALSE, engine="sh"------------------------------
## R CMD build longevityTools # Run from parent directory of longevityTools directory
## R CMD check longevityTools_1.0.3.tar.gz
## install.package("longevityTools_1.0.3.tar.gz", repos=NULL, type="source")

## ----sessionInfo---------------------------------------------------------
sessionInfo()

