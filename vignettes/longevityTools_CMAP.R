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

## ----normalize_chips, eval=FALSE-----------------------------------------
## library(BiocParallel); library(BatchJobs); library(affy)
## chiptype_list <- split(names(chiptype), as.character(chiptype))
## normalizeCel(chiptype_list, rerun=FALSE) # Note: expect in pwd files torque.tmpl and .BatchJobs.R

## ----comb_chip_type_data, eval=FALSE-------------------------------------
## chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
## combineResults(chiptype_dir, rerun=FALSE)

## ----cleanup1, eval=FALSE------------------------------------------------
## # for(i in seq_along(chiptype_dir)) unlink(list.files(paste0("data/", chiptype_dir[i]), pattern="cellbatch", full.names=TRUE), recursive=TRUE)
## # unlink("data/CEL/") # Deletes downloaded CEL files

## ----cel_file_list, eval=FALSE-------------------------------------------
## cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE) # Note: cmap_instances_02.xls converted to txt with LibreOffice
## # comp_list <- sampleList(cmap, myby="CMP")
## comp_list <- sampleList(cmap, myby="CMP_CELL")

## ----load_mas5_data, eval=FALSE------------------------------------------
## chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
## df1 <- readRDS(paste0("data/", chiptype_dir[1], "/", "all_mas5exprs.rds"))
## df2 <- readRDS(paste0("data/", chiptype_dir[2], "/", "all_mas5exprs.rds"))
## df3 <- readRDS(paste0("data/", chiptype_dir[3], "/", "all_mas5exprs.rds"))
## affyid <- rownames(df1)[rownames(df1) %in% rownames(df2)]; affyid <- affyid[affyid %in% rownames(df3)]
## df <- cbind(df1[affyid,], df2[affyid,], df3[affyid,])

## ----deg_limma, eval=FALSE-----------------------------------------------
## degMA <- runLimma(df, comp_list, fdr=0.10, foldchange=1, verbose=TRUE)
## write.table(degMA, file="./results/degMA.xls", quote=FALSE, sep="\t", col.names = NA)

## ----affyid_annotations, eval=TRUE---------------------------------------
suppressMessages(library(hgu133a.db))
myAnnot <- data.frame(ACCNUM=sapply(contents(hgu133aACCNUM), paste, collapse=", "), 
                             SYMBOL=sapply(contents(hgu133aSYMBOL), paste, collapse=", "), 
                             UNIGENE=sapply(contents(hgu133aUNIGENE), paste, collapse=", "), 
                             ENTREZID=sapply(contents(hgu133aENTREZID), paste, collapse=", "), 
                             ENSEMBL=sapply(contents(hgu133aENSEMBL), paste, collapse=", "), 
                             DESC=sapply(contents(hgu133aGENENAME), paste, collapse=", "))

## ----deg_overlaps, eval=TRUE---------------------------------------------
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#")
affyid <- row.names(myAnnot[myAnnot$ENTREZID %in% PMID26490707$"NEW.Entrez.ID",])
degMA <- read.delim("./results/degMA.xls", row.names=1, check.names=FALSE)
degMA <- degMA[ , !is.na(colSums(degMA))] # Remove columns where DEG analysis was not possible
degMAsub <- degMA[affyid,]
c <- colSums(degMAsub==1) # Common in both (c)
a <- colSums(degMAsub==0) # Only in query (a)
b <- colSums(degMA==1) - c # Only in cmap (b)
j <- c/(c+a+b) # Jaccard similarity 
sort(j, decreasing=TRUE)[1:10]

## ----sessionInfo---------------------------------------------------------
sessionInfo()

