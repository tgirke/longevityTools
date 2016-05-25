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
## biocLite("tgirke/longevityDrugs", build_vignettes=FALSE, dependencies=FALSE)

## ----documentation, eval=TRUE--------------------------------------------
library(RSQLite); library(ChemmineR); library(longevityDrugs)

## ----load_database, eval=TRUE--------------------------------------------
mypath <- system.file("extdata", "cmap.db", package="longevityDrugs")
conn <- initDb(mypath)

## ----query_structures, eval=TRUE-----------------------------------------
results <- getAllCompoundIds(conn)
sdfset <- getCompounds(conn, results, keepOrder=TRUE)
sdfset
plot(sdfset[1:4], print=FALSE)
as.data.frame(datablock2ma(datablock(sdfset)))[1:4,]

## ----query_properties, eval=TRUE-----------------------------------------
myfeat <- listFeatures(conn)
feat <- getCompoundFeatures(conn, results, myfeat)
feat[1:4,]

## ----sessionInfo---------------------------------------------------------
sessionInfo()

