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
## vignette(topic="longevityTools_eDRUG", package="longevityTools") # Opens vignette

## ----source_fct, eval=TRUE-----------------------------------------------
fctpath <- system.file("extdata", "longevityTools_eDRUG_Fct.R", package="longevityTools")
source(fctpath)

## ----work_envir, eval=FALSE----------------------------------------------
## dir.create("data"); dir.create("data/CEL"); dir.create("results")

## ----download_cmap, eval=FALSE-------------------------------------------
## getCmap(rerun=FALSE) # Downloads cmap rank matrix and compound annotation files
## getCmapCEL(rerun=FALSE) # Download cmap CEL files. Note, this will take some time

## ----get_cel_type, eval=FALSE--------------------------------------------
## celfiles <- list.files("./data/CEL", pattern=".CEL$")
## chiptype <- sapply(celfiles, function(x) affxparser::readCelHeader(paste0("data/CEL/", x))$chiptype)
## if(FALSE) saveRDS(chiptype, "./data/chiptype.rds") # if(FALSE) protects this line from accidental execution!

## ----normalize_chips, eval=FALSE-----------------------------------------
## library(BiocParallel); library(BatchJobs); library(affy)
## chiptype <- readRDS("./data/chiptype.rds")
## chiptype_list <- split(names(chiptype), as.character(chiptype))
## normalizeCel(chiptype_list, rerun=FALSE)

## ----comb_chip_type_data, eval=FALSE-------------------------------------
## chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
## combineResults(chiptype_dir, rerun=FALSE)

## ----cleanup1, eval=FALSE------------------------------------------------
## for(i in seq_along(chiptype_dir)) unlink(list.files(paste0("data/", chiptype_dir[i]), pattern="cellbatch", full.names=TRUE), recursive=TRUE)
## unlink("data/CEL/*.CEL") # Deletes downloaded CEL files

## ----cel_file_list, eval=FALSE-------------------------------------------
## cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE)
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
## saveRDS(degMA, "./results/degMA.rds")

## ----affyid_annotations, eval=FALSE, message=FALSE-----------------------
## library(hgu133a.db)
## myAnnot <- data.frame(ACCNUM=sapply(contents(hgu133aACCNUM), paste, collapse=", "),
##                              SYMBOL=sapply(contents(hgu133aSYMBOL), paste, collapse=", "),
##                              UNIGENE=sapply(contents(hgu133aUNIGENE), paste, collapse=", "),
##                              ENTREZID=sapply(contents(hgu133aENTREZID), paste, collapse=", "),
##                              ENSEMBL=sapply(contents(hgu133aENSEMBL), paste, collapse=", "),
##                              DESC=sapply(contents(hgu133aGENENAME), paste, collapse=", "))
## saveRDS(myAnnot, "./results/myAnnot.rds")

## ----deg_overlaps_PMID26490707, eval=TRUE--------------------------------
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#")
myAnnot <- readRDS("./results/myAnnot.rds") 
affyid <- row.names(myAnnot[myAnnot$ENTREZID %in% PMID26490707$"NEW.Entrez.ID",])
# degMA <- read.delim("./results/degMA.xls", row.names=1, check.names=FALSE)
degMA <- readRDS("./results/degMA.rds") # Faster then read.delim()
degMA <- degMA[ , !is.na(colSums(degMA))] # Remove columns where DEG analysis was not possible
degMAsub <- degMA[affyid,]
c <- colSums(degMAsub==1) # Common in both (c)
a <- colSums(degMAsub==0) # Only in query (a)
b <- colSums(degMA==1) - c # Only in cmap (b)
j <- c/(c+a+b) # Jaccard similarity 
r <- sort(j, decreasing=TRUE)
degOL_PMID26490707 <- data.frame(CMP=names(r), Jaccard_Index=as.numeric(r))
write.table(degOL_PMID26490707, file="./results/degOL_PMID26490707.xls", quote=FALSE, sep="\t", col.names = NA) 
sum(degOL_PMID26490707[,2] > 0) # Drugs with any overlap
degOL_PMID26490707[1:20,] # Top 20 scoring drugs

## ----deg_overlaps_PMID26343147, eval=TRUE--------------------------------
PMID26343147 <- read.delim("./data/PMID26343147_S1T1.xls", check.names=FALSE, comment="#")
myAnnot <- readRDS("./results/myAnnot.rds") 
affyid <- row.names(myAnnot[myAnnot[,"SYMBOL"] %in% PMID26343147[,"Gene Symbol"], ]) 
degMA <- readRDS("./results/degMA.rds") # Faster then read.delim()
degMA <- degMA[ , !is.na(colSums(degMA))] # Remove columns where DEG analysis was not possible
degMAsub <- degMA[affyid,]
c <- colSums(degMAsub==1) # Common in both (c)
a <- colSums(degMAsub==0) # Only in query (a)
b <- colSums(degMA==1) - c # Only in cmap (b)
j <- c/(c+a+b) # Jaccard similarity 
r <- sort(j, decreasing=TRUE)
degOL_PMID26343147 <- data.frame(CMP=names(r), Jaccard_Index=as.numeric(r))
write.table(degOL_PMID26343147, file="./results/degOL_PMID26343147.xls", quote=FALSE, sep="\t", col.names = NA) 
degOL_PMID26343147[1:20,]

## ----deg_queries, eval=TRUE----------------------------------------------
affyids <- row.names(myAnnot[myAnnot$SYMBOL %in% c("IGF1", "IGF1R"),])
degMA <- readRDS("./results/degMA.rds") # Faster then read.delim()
q <- colSums(degMA[affyids,])
q <- q[q > 0]
length(q)
as.data.frame(rev(sort(q))[1:20])

## ----drug_enrichment, eval=TRUE, message=FALSE---------------------------
library(DrugVsDisease)
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#", check.names=FALSE)
data(drugRL)
PMID26490707sub <- PMID26490707[PMID26490707[,"NEW-Gene-ID"] %in% rownames(drugRL),]
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
drugcmap <- classifyprofile(data=testprofiles$ranklist, case="disease", signif.fdr=0.5, no.signif=20)
drugcmap2 <- classifyprofile(data=testprofiles$ranklist, case="disease", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=0.5, signif.fdr=0.05, adj="BH", no.signif=100)
write.table(drugcmap2, file="./results/drugcmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
drugcmap2[[1]][1:20,]

## ----disease_enrichment, eval=TRUE, message=TRUE-------------------------
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#", check.names=FALSE)
data(diseaseRL)
PMID26490707sub <- PMID26490707[PMID26490707[,"NEW-Gene-ID"] %in% rownames(diseaseRL),]
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
diseasecmap <- classifyprofile(data=testprofiles$ranklist, case="drug", signif.fdr=0.5, no.signif=20)
diseasecmap2 <- classifyprofile(data=testprofiles$ranklist, case="drug", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=0.5, adj="BH", no.signif=100)
write.table(diseasecmap2, file="./results/diseasecmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
diseasecmap2[[1]][1:20,]

## ----sessionInfo---------------------------------------------------------
sessionInfo()

