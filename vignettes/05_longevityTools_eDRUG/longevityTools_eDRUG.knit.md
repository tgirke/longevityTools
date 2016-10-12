---
title: "_longevityTools_: Connecting Drug- and Age-related Gene Expression Signatures" 
author: "Authors: Thomas Girke, Danjuma Quarless, Tyler Backman, Kuan-Fu Ding, Jamison McCorrison, Nik Schork, Dan Evans"
date: "Last update: 11 October, 2016" 
package: "longevityTools 1.0.6"
output:
  BiocStyle::html_document:
    toc: true
    toc_depth: 3
    fig_caption: yes

fontsize: 14pt
bibliography: bibtex.bib
---
<!--
%% \VignetteEngine{knitr::rmarkdown}
%\VignetteIndexEntry{Overview Vignette}
%% \VignetteDepends{methods}
%% \VignetteKeywords{compute cluster, pipeline, reports}
%% \VignettePackage{longevityTools}
-->

<!---
- Compile from command-line
echo "rmarkdown::render('longevityTools_eDRUG.Rmd', clean=F)" | R -slave; R CMD Stangle longevityTools_eDRUG.Rmd

- Commit to github
git commit -am "some edits"; git push -u origin master

- To customize font size and other style features, add this line to output section in preamble:  
    css: style.css
-->

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
  document.querySelector("h1").className = "title";
});
</script>
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
  var links = document.links;  
  for (var i = 0, linksLength = links.length; i < linksLength; i++)
    if (links[i].hostname != window.location.hostname)
      links[i].target = '_blank';
});
</script>



# Introduction 
This vignette is part of the NIA funded Longevity Genomics project. For more information on this project please visit its 
website [here](http://www.longevitygenomics.org/projects/). The GitHub repository of the corresponding R package 
is available <a href="https://github.com/tgirke/longevityTools">here</a> and the most recent version of this 
vignette can be found <a href="https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eDRUG.html">here</a>.

The project component covered by this vignette analyzes drug- and age-related
genome-wide expression data from public microarray and RNA-Seq experiments. One
of the main objective is the identification drug candidates modulating the
expression of longevity genes and pathways. For this, we compare age-related
expression signatures with those from drug treamtments. The age-related query
signatures are from recent publications such as Peters et al. [-@Peters2015-fc]
and Sood et al. [-@Sood2015-pb], while the drug-related reference signatures
are from the Connectivity Map (CMAP) and LINCS projects [@Lamb2006-uv].

<div align="right">[Back to Table of Contents]()</div>


# Getting Started

## Installation

The R software for running [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


```r
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE) # Installs package from GitHub
```
<div align="right">[Back to Table of Contents]()</div>

## Loading package and documentation


```r
library("longevityTools") # Loads the package
library(help="longevityTools") # Lists package info
vignette(topic="longevityTools_eDRUG", package="longevityTools") # Opens vignette
```
<div align="right">[Back to Table of Contents]()</div>

# Setup of working environment

## Import custom functions 

Preliminary functions that are still under developement, or not fully tested and documented 
can be imported with the `source` command from the `inst/extdata` directory of the package.


```r
fctpath <- system.file("extdata", "longevityTools_eDRUG_Fct.R", package="longevityTools")
source(fctpath)
```
<div align="right">[Back to Table of Contents]()</div>

## Create expected directory structure 

The following creates the directory structure expected by this workflow. Input data
will be stored in the `data` directory and results will be written to the `results` directory.
All paths are given relative to the present working directory of the user's R session.


```r
dir.create("data"); dir.create("data/CEL"); dir.create("results") 
```

<div align="right">[Back to Table of Contents]()</div>

# Data downloads

## Download data from Connectivity Map project site
The drug-related expression data are downloaded from the CMAP web site
[here](http://www.broadinstitute.org/cmap).  The `getCmap` function downloads
the CMAP rank matrix along with the compound annotations, and `getCmapCEL`
downloads the corresponding 7,056 CEL files. The functions will write the
downloaded files to the `data` and `data/CEL` directories within the present 
working directory of the user's R session. Since some of the raw data sets 
are large, the functions will only rerun the download if the argument `rerun` 
is assigned `TRUE`. If the raw data are not needed then users can skip this 
time consuming download step and work with the preprocessed data 
obtained in the next section.


```r
getCmap(rerun=FALSE) # Downloads cmap rank matrix and compound annotation files
getCmapCEL(rerun=FALSE) # Download cmap CEL files. Note, this will take some time
```

<div align="right">[Back to Table of Contents]()</div>

## Overview of CMAP data

The experimental design of the CMAP project is defined in the file
`cmap_instances_02.xls`.  Note, this file required some cleaning in LibreOffice
(Excel would work for this too). After this it was saved as tab delimited txt
file named
[cmap_instances_02.txt](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/cmap_instances_02.txt).
The following count statisitics are extracted from this file.

The panel of cell lines used by CMAP includes 
[MCF7](http://www.broadinstitute.org/cmap/help_topics_linkified.jsp#mcf7), 
[ssMCF7](http://www.broadinstitute.org/cmap/help_topics_linkified.jsp#mcf7), 
[HL60](http://www.broadinstitute.org/cmap/help_topics_linkified.jsp#hl60), 
[PC3](http://www.broadinstitute.org/cmap/help_topics_linkified.jsp#pc3) and 
[SKMEL5](http://www.broadinstitute.org/cmap/help_topics_linkified.jsp#skmel5). 
Each cell type was subjected to the following number of total treatments and number
of distinct drugs, respectively. The total number of drugs used by CMAP is 1,309.


```r
library(ggplot2); library(reshape2) 
cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE) 
df <- data.frame(table(cmap[, "cell2"]), as.numeric(table(cmap[!duplicated(paste0(cmap$cmap_name, cmap$cell2)),"cell2"])))
colnames(df) <- c("Cell_type", "Treatments", "Drugs")
df <- melt(df, id.vars=c("Cell_type"), variable.name = "Samples", value.name="Counts")
ggplot(df, aes(Cell_type, Counts, fill=Samples)) + 
       geom_bar(position="dodge", stat="identity") + 
       ggtitle("Number of treatments by cell types")
```

![](longevityTools_eDRUG_files/figure-html/overview_cmap_drugs-1.png)<!-- -->

The number Affymetrix chip used in the experiments is plotted here for each of
the three chip types used by CMAP:


```r
df <- data.frame(table(cmap$array3)); colnames(df) <- c("Chip_type", "Counts") 
ggplot(df, aes(Chip_type, Counts)) + 
       geom_bar(position="dodge", stat="identity", fill="cornflowerblue") + 
       ggtitle("Number of chip types")
```

![](longevityTools_eDRUG_files/figure-html/overview_cmap_chip_type-1.png)<!-- -->

<div align="right">[Back to Table of Contents]()</div>

# Pre-processing of CEL files

## Determine chip type from CEL files 
The CMAP data set is based on three different Affymetrix chip types (HG-U133A,
HT_HG-U133A and U133AAofAv2). The following extracts the chip type information
from the CEL files and stores the result in an `rds` file with the path 
`./data/chiptype.rds`. Users who skipped the download of the CEL files can
download this file [here](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/chiptype.rds).


```r
celfiles <- list.files("./data/CEL", pattern=".CEL$")
chiptype <- sapply(celfiles, function(x) affxparser::readCelHeader(paste0("data/CEL/", x))$chiptype)
if(FALSE) saveRDS(chiptype, "./data/chiptype.rds") # if(FALSE) protects this line from accidental execution!
```

<div align="right">[Back to Table of Contents]()</div>

## Normalization of CEL files

The follwoing processes the CEL files from each chip type separately using the
MAS5 normalization algorithm. The results will be written to 3 subdirectores
under `data` that are named after the chip type names.  To save time, the
processing is parallelized with `BiocParallel` to run on 100 CPU cores of a
computer cluster with a scheduler (_e.g._ Torque). The number of CEL files from
each chip type are: 807 CEL files from HG-U133A, 6029 CEL files from
HT_HG-U133A, and 220 CEL files from U133AAofAv2. Note, these numbers are slightly
different than those reported in the `cmap_instances_02.txt` file. The MAS5 normalized data
sets can be downloaded here: 
[HG-U133A](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/HG-U133A/all_mas5exprs.rds), 
[HT_HG-U133A](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/HT_HG-U133A/all_mas5exprs.rds), 
[U133AAofAv2](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/data/U133AAofAv2/all_mas5exprs.rds).



```r
library(BiocParallel); library(BatchJobs); library(affy)
chiptype <- readRDS("./data/chiptype.rds")
chiptype_list <- split(names(chiptype), as.character(chiptype))
normalizeCel(chiptype_list, rerun=FALSE) 
```

<div align="right">[Back to Table of Contents]()</div>

## Combine results from same chip type in single data frame


```r
chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
combineResults(chiptype_dir, rerun=FALSE)
```

<div align="right">[Back to Table of Contents]()</div>

## Clean-up of intermediate files

This deletes intermediate files. Before executing these lines, please make sure that this is what you want.


```r
for(i in seq_along(chiptype_dir)) unlink(list.files(paste0("data/", chiptype_dir[i]), pattern="cellbatch", full.names=TRUE), recursive=TRUE)
unlink("data/CEL/*.CEL") # Deletes downloaded CEL files
```

<div align="right">[Back to Table of Contents]()</div>

## Obtain annotation information
The following generates annotation information for the Affymetirx probe set
identifiers. Note, the three different Affymetrix chip types used by CMAP
share most probe set ids (>95%), meaning it is possible to combine the data
after normalization and use the same annotation package for all of them. The
annotation libraries for the chip types HG-U133A and HT_HG-U133A are
`hgu133a.db` and `hthgu133a.db`, respectively. However, there is no annotation 
library (e.g. CDF) available for U133AAofAv2. The annotation file can be downloaded
from here: [`myAnnot.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/myAnnot.xls).


```r
library(hgu133a.db)
myAnnot <- data.frame(ACCNUM=sapply(contents(hgu133aACCNUM), paste, collapse=", "), 
                             SYMBOL=sapply(contents(hgu133aSYMBOL), paste, collapse=", "), 
                             UNIGENE=sapply(contents(hgu133aUNIGENE), paste, collapse=", "), 
                             ENTREZID=sapply(contents(hgu133aENTREZID), paste, collapse=", "), 
                             ENSEMBL=sapply(contents(hgu133aENSEMBL), paste, collapse=", "), 
                             DESC=sapply(contents(hgu133aGENENAME), paste, collapse=", "))
write.table(myAnnot, file="./results/myAnnot.xls", quote=FALSE, sep="\t", col.names = NA) 
saveRDS(myAnnot, "./results/myAnnot.rds")
```

<div align="right">[Back to Table of Contents]()</div>

# DEG analysis with `limma`

## Generate list of CEL names defining treatment vs. control comparisons

The `sampleList` function extracts the sample comparisons (contrasts) from the
CMAP annotation table and stores them as a list.


```r
cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE) 
# comp_list <- sampleList(cmap, myby="CMP")
comp_list <- sampleList(cmap, myby="CMP_CELL")
```

<div align="right">[Back to Table of Contents]()</div>

## Load normalized expression data 

The following loads the MAS5 normalized expression data into a single `data.frame`. 
To accelerate the import, the data is read from `rds` files. 


```r
chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
df1 <- readRDS(paste0("data/", chiptype_dir[1], "/", "all_mas5exprs.rds"))
df2 <- readRDS(paste0("data/", chiptype_dir[2], "/", "all_mas5exprs.rds"))
df3 <- readRDS(paste0("data/", chiptype_dir[3], "/", "all_mas5exprs.rds"))
affyid <- rownames(df1)[rownames(df1) %in% rownames(df2)]; affyid <- affyid[affyid %in% rownames(df3)]
mas5df <- cbind(df1[affyid,], df2[affyid,], df3[affyid,])
```

## Transform probe set to gene level data
The next step generates gene level expression values. If genes are represented by several
probe sets then their mean intensities are used. This is necessary because 
the U133 chip contains many genes with duplicated probe sets. Probe sets not matching 
any gene are removed.


```r
myAnnot <- readRDS("./results/myAnnot.rds") 
myAnnot <- myAnnot[as.character(myAnnot[,"ENTREZID"]) != "NA",]
mas5df <- mas5df[rownames(myAnnot),]
idlist <- tapply(row.names(myAnnot), as.character(myAnnot$ENTREZID), c)
mas5df <- t(sapply(names(idlist), function(x) colMeans(mas5df[idlist[[x]], ])))
```

<div align="right">[Back to Table of Contents]()</div>

## DEG analysis with `limma`

The analysis of differentially expressed genes (DEGs) is performed with the `limma` package.
Genes meeting the chosen cutoff criteria are reported as DEGs (below set to FDR of 10% and 
a minimum fold change of 2). The DEG matrix is written to a file named 
[`degMA.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/degMA.xls).


```r
degList <- runLimma(df=log2(mas5df), comp_list, fdr=0.10, foldchange=1, verbose=TRUE, affyid=NULL)
write.table(degList$DEG, file="./results/degMA.xls", quote=FALSE, sep="\t", col.names = NA) 
saveRDS(degList$DEG, "./results/degMA.rds") # saves binary matrix 
saveRDS(degList, "./results/degList.rds") # saves entire degList
```

<div align="right">[Back to Table of Contents]()</div>

<!-- Not neceassary anymore since intensities of genes with multiple probe sets are averaged
## Transform probe set to gene level data

The `probeset2gene` function translates a binary DEG matrix from the probe level (`row.names` are
Affy IDs) to the gene level (`row.names` are gene IDs). Genes represented by several probe
sets (rows) will be collapsed based on a chosen summary rule. The following summary rules are
supported: `summary_rule=1L` will consider a gene as a DEG for a specific treatment if at 
least one of several probe sets supports this assignment, while `summary_rule=2L` requires 
support from at least 2 probe sets.


```r
myAnnot <- readRDS("./results/myAnnot.rds") 
degMA <- readRDS("./results/degMA.rds") # Faster than read.delim()
degMAgene <- probeset2gene(degMA, myAnnot, geneIDtype="ENTREZID", summary_rule=1L)
saveRDS(degMAgene, "./results/degMAgene.rds")
```
<div align="right">[Back to Table of Contents]()</div>
--> 

## Number of DEGs across drug treatments

The following plots the number of drug treatments (y-axis) for increasing bin sizes (x-axis) 
of DEGs. 


```r
degMAgene <- readRDS("./results/degMA.rds")
y <- as.numeric(colSums(degMAgene))
interval <- table(cut(y, right=FALSE, dig.lab=5,  breaks=c(0, 5, 10, 50, 100, 200, 500, 1000, 10000)))
df <- data.frame(interval); colnames(df) <- c("Bins", "Counts")
ggplot(df, aes(Bins, Counts)) + 
       geom_bar(position="dodge", stat="identity", fill="cornflowerblue") + 
       ggtitle("DEG numbers by bins")
```

![](longevityTools_eDRUG_files/figure-html/deg_distr-1.png)<!-- -->

<div align="right">[Back to Table of Contents]()</div>

## Identify DEG overlaps with Peters et al. [-@Peters2015-fc]

Peters et al. [-@Peters2015-fc] reported 1,497 age-related gene expression
signatures.  The `intersectStats` function computes their intersects with each
of the 3,318 drug-responsive DEG sets from CMAP. The result includes the
Jaccard index as a simple similarity metric for gene sets as well as the raw
and adjusted p-values based on the hypergeometric distribution expressing how
likely it is to obtain the observed intersect sizes just by chance. The
results for the 20 top scoring drugs are given below and the full data set is
written to a file named
[`degOL_PMID26490707.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/degOL_PMID26490707.xls).


```r
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#")
myAnnot <- readRDS("./results/myAnnot.rds") 
geneid <- as.character(PMID26490707$"NEW.Entrez.ID")
degMAgene <- readRDS("./results/degMA.rds") # Faster than read.delim()
degMAsub <- degMAgene[rownames(degMAgene) %in% geneid,]
degOL_PMID26490707 <- intersectStats(degMAgene, degMAsub)
write.table(degOL_PMID26490707, file="./results/degOL_PMID26490707.xls", quote=FALSE, sep="\t", col.names = NA) 
sum(degOL_PMID26490707[,1] > 0) # Drugs with any overlap
```

```
## [1] 1137
```

```r
degOL_PMID26490707[1:20,]
```

```
##                                Jaccard_Index longevity_DEG cmap_DEG Intersect         Pval
## alprostadil_HL60                  0.10272537          1192      912       196 1.706881e-29
## dihydroergotamine_HL60            0.06187625          1192      404        93 3.698500e-16
## pergolide_HL60                    0.07815080          1192      767       142 2.631561e-15
## (-)-isoprenaline_HL60             0.05113636          1192      288        72 1.087773e-14
## Prestwick-983_HL60                0.05948447          1192      411        90 2.785586e-14
## nocodazole_HL60                   0.06384324          1192      491       101 4.863951e-14
## anisomycin_HL60                   0.09790419          1192     2475       327 2.312553e-11
## tetryzoline_HL60                  0.03366488          1192      159        44 4.993036e-11
## mebendazole_HL60                  0.06041924          1192      528        98 6.663275e-11
## methylergometrine_HL60            0.04436620          1192      291        63 3.825164e-10
## lycorine_HL60                     0.09093994          1192     2023       268 2.411922e-09
## podophyllotoxin_HL60              0.04175513          1192      280        59 4.108204e-09
## colchicine_HL60                   0.03181818          1192      170        42 5.960591e-09
## co-dergocrine mesilate_HL60       0.05239617          1192      455        82 1.062344e-08
## puromycin_HL60                    0.05060858          1192      448        79 5.282895e-08
## tretinoin_HL60                    0.03738318          1192      251        52 6.182212e-08
## 15-delta prostaglandin J2_HL60    0.04560698          1192      367        68 6.583181e-08
## geldanamycin_HL60                 0.03068862          1192      185        41 2.331048e-07
## bromocriptine_HL60                0.02739726          1192      158        36 6.194257e-07
## apigenin_HL60                     0.06292967          1192      818       119 1.601978e-06
##                                    adj_Pval
## alprostadil_HL60               5.936533e-26
## dihydroergotamine_HL60         1.286338e-12
## pergolide_HL60                 9.152569e-12
## (-)-isoprenaline_HL60          3.783276e-11
## Prestwick-983_HL60             9.688270e-11
## nocodazole_HL60                1.691682e-10
## anisomycin_HL60                8.043059e-08
## tetryzoline_HL60               1.736578e-07
## mebendazole_HL60               2.317487e-07
## methylergometrine_HL60         1.330392e-06
## lycorine_HL60                  8.388664e-06
## podophyllotoxin_HL60           1.428833e-05
## colchicine_HL60                2.073093e-05
## co-dergocrine mesilate_HL60    3.694832e-05
## puromycin_HL60                 1.837391e-04
## tretinoin_HL60                 2.150173e-04
## 15-delta prostaglandin J2_HL60 2.289630e-04
## geldanamycin_HL60              8.107384e-04
## bromocriptine_HL60             2.154363e-03
## apigenin_HL60                  5.571679e-03
```

<div align="right">[Back to Table of Contents]()</div>

## Identify DEG overlaps with Sood et al. [-@Sood2015-pb]

Sood et al. [-@Sood2015-pb] reported 150 age-related gene expression signatures. 
The `intersectStats` function computes their intersects with each of the 3,318 
drug-responsive DEG sets from CMAP. The result includes the Jaccard index as a simple 
similarity metric for gene sets as well as the raw and adjusted p-values based on the 
hypergeometric distribution expressing how likely it is to observe the observed intersect 
sizes just by chance. The results for the 20 top scoring drugs are given below and the full
data set is written to a file named [`degOL_PMID26343147.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/degOL_PMID26343147.xls).


```r
PMID26343147 <- read.delim("./data/PMID26343147_S1T1.xls", check.names=FALSE, comment="#")
myAnnot <- readRDS("./results/myAnnot.rds") 
geneid <- as.character(myAnnot[rownames(myAnnot) %in% as.character(PMID26343147[,1]), "ENTREZID"])
geneid <- geneid[geneid!="NA"]
degMA <- readRDS("./results/degMA.rds") # Faster then read.delim()
degMA <- degMA[ , !is.na(colSums(degMA))] # Remove columns where DEG analysis was not possible
degMAsub <- degMA[geneid,]
degOL_PMID26343147 <- intersectStats(degMAgene, degMAsub)
write.table(degOL_PMID26343147, file="./results/degOL_PMID26343147.xls", quote=FALSE, sep="\t", col.names = NA) 
sum(degOL_PMID26343147[,1] > 0) # Drugs with any overlap
```

```
## [1] 223
```

```r
degOL_PMID26343147[1:20,] # Top 20 scoring drugs
```

```
##                        Jaccard_Index longevity_DEG cmap_DEG Intersect        Pval adj_Pval
## colecalciferol_MCF7      0.017857143            55        2         1 0.008821835        1
## esculin_HL60             0.017857143            55        2         1 0.008821835        1
## flecainide_MCF7          0.017857143            55        2         1 0.008821835        1
## ribostamycin_MCF7        0.017857143            55        2         1 0.008821835        1
## withaferin A_MCF7        0.016000000            55      199         4 0.011470972        1
## dexamethasone_HL60       0.022222222            55       37         2 0.011573654        1
## lobeline_HL60            0.007987220            55     1838        15 0.011600566        1
## idoxuridine_MCF7         0.017543860            55        3         1 0.013204054        1
## metronidazole_MCF7       0.017543860            55        3         1 0.013204054        1
## sulpiride_MCF7           0.017543860            55        3         1 0.013204054        1
## ampyrone_HL60            0.008880995            55     1081        10 0.018769135        1
## chlortetracycline_HL60   0.008080808            55     1442        12 0.021597597        1
## estropipate_MCF7         0.016949153            55        5         1 0.021911500        1
## flunixin_PC3             0.016949153            55        5         1 0.021911500        1
## sulfafurazole_HL60       0.018867925            55       53         2 0.022894704        1
## (-)-MK-801_MCF7          0.016666667            55        6         1 0.026236889        1
## carbarsone_PC3           0.016666667            55        6         1 0.026236889        1
## famprofazone_HL60        0.016666667            55        6         1 0.026236889        1
## guanethidine_HL60        0.016666667            55        6         1 0.026236889        1
## cefalotin_MCF7           0.016393443            55        7         1 0.030543497        1
```
<div align="right">[Back to Table of Contents]()</div>

## Drugs affecting known longevity genes

The following identifies CMAP drugs affecting the expression of the IGF1 or IGF1R genes.
The final result is written to a file named [`deg_IGF1.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/deg_IGF1.xls).


```r
genesymbols <- c("IGF1", "IGF1R")
geneids <- unique(as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"ENTREZID"]))
names(geneids) <- unique(as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"SYMBOL"]))
degList <- readRDS("./results/degList.rds") 
df <- data.frame(row.names=colnames(degList$DEG), check.names=FALSE)
index <- which(colSums(degList$DEG[geneids,])>= 1) 
for(i in seq_along(geneids)) {
    tmp <- data.frame(DEG=degList$DEG[geneids[i],index], logFC=degList$logFC[geneids[i],index], FDR=degList$FDR[geneids[i],index])
    colnames(tmp) <- paste0(names(geneids)[i], "_", colnames(tmp))
    df <- cbind(df, tmp[rownames(df),] )    
}
df <- df[names(index),]
write.table(df, file="./results/deg_IGF1.xls", quote=FALSE, sep="\t", col.names = NA) 
```

Now the final `data.frame` can be sorted by increasing mean FDR values. 

```r
igfDF <- read.delim("./results/deg_IGF1.xls", row.names=1)
igfDF[order(rowMeans(igfDF[,c(3,6)])),][1:20,]
```

```
##                                IGF1R_DEG IGF1R_logFC     IGF1R_FDR IGF1_DEG  IGF1_logFC   IGF1_FDR
## camptothecin_MCF7                      1 -1.48180690  4.867357e-07        0  0.94295576 0.07821138
## 0175029-0000_MCF7                      0 -0.62026588  1.193479e-01        1 -1.01210916 0.04295254
## cicloheximide_HL60                     1 -1.29607754  2.054384e-02        0  1.67183429 0.16908728
## emetine_HL60                           1 -1.23843896  3.085463e-03        0  1.03812083 0.26576009
## digoxigenin_PC3                        0  0.54850849  2.488776e-01        1 -1.27142976 0.04219010
## anisomycin_HL60                        1 -2.85399433  1.481347e-03        0  0.66701644 0.44025263
## vorinostat_MCF7                        1 -1.50640830  3.143781e-17        0  0.37179771 0.45437384
## irinotecan_MCF7                        1 -2.26588384  9.895790e-02        0 -1.05446828 0.41746319
## tyrphostin AG-825_MCF7                 1 -1.03570748  3.440048e-02        0  1.57208567 0.51400841
## trichostatin A_MCF7                    1 -1.27541131 6.943847e-127        0  0.07335895 0.55046789
## baclofen_HL60                          1  1.14379132  8.226627e-02        0 -1.00641253 0.53322529
## 8-azaguanine_PC3                       1 -1.04668136  7.466879e-02        0 -0.97679589 0.65221001
## verteporfin_MCF7                       1 -1.11136304  1.226251e-03        0  0.64194152 0.78463681
## piperlongumine_MCF7                    1 -1.03214332  1.088011e-02        0  0.53820854 0.78914488
## verteporfin_HL60                       1 -1.17232840  4.923492e-02        0  1.09438523 0.75358370
## cephaeline_HL60                        1 -1.13448661  1.479635e-02        0 -0.19882135 0.86619935
## lycorine_HL60                          1 -1.93807396  1.390079e-03        0 -0.23062131 0.88748758
## doxorubicin_MCF7                       1 -1.08389932  4.035039e-04        0  0.12613722 0.92452703
## anisomycin_MCF7                        0  0.06265744  8.938603e-01        1 -1.55915713 0.04355888
## 15-delta prostaglandin J2_MCF7         0  0.01396391  9.774076e-01        1  1.03626957 0.09233156
```

<!-- old version

```r
genesymbols <- c("IGF1", "IGF1R")
geneids <- unique(as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"ENTREZID"]))
names(geneids) <- unique(as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"SYMBOL"]))
degMAgene <- readRDS("./results/degMA.rds") # Faster than read.delim()
df <- data.frame(row.names=colnames(degMAgene), check.names=FALSE)
for(i in seq_along(geneids)) df <- cbind(df, as.numeric(degMAgene[geneids[i],]))
colnames(df) <- names(geneids)
df <- df[rowSums(df)>0,]
nrow(df) # Number of drugs affecting at least one of: IGF1 or IGF1R
```

```
## [1] 20
```

The following computes the `limma` FDR values for the corresponding genes (here IGF1 and IGF1R) 
and drug treatments.

```r
affyids2 <- row.names(myAnnot[myAnnot$SYMBOL %in% genesymbols,])
affyids <- as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"SYMBOL"])
names(affyids) <- affyids2
cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE) 
comp_list <- sampleList(cmap, myby="CMP_CELL")
comp_list <- comp_list[row.names(df)]
degList <- runLimma(df=mas5df, comp_list, fdr=0.10, foldchange=1, verbose=FALSE, affyid=names(affyids))
pvalDF <- sapply(unique(affyids), function(x) sapply(rownames(df), function(y) min(degList[[y]][affyids==x,"adj.P.Val"])))
colnames(pvalDF) <- paste0(colnames(pvalDF), "_FDR")
df <- cbind(df, pvalDF)
write.table(df, file="./results/deg_IGF1.xls", quote=FALSE, sep="\t", col.names = NA) 
```
--> 
<div align="right">[Back to Table of Contents]()</div>


## Plot structures of compounds


```r
library(ChemmineR)
mypath <- system.file("extdata", "longevitydrugs.sdf", package="longevityTools")
mypath <- "../inst/extdata/longevitydrugs.sdf"
sdfset <- read.SDFset(mypath)
data(sdfsample)
sdfsample
```

```
## An instance of "SDFset" with 100 molecules
```

```r
plot(sdfsample[1:4], print=FALSE)
```

![](longevityTools_eDRUG_files/figure-html/plot_sdf-1.png)<!-- -->
<div align="right">[Back to Table of Contents]()</div>


# Connectivity maps enrichment analysis

The connectivity maps approach is a rank-based enrichment method utilizing the KS test [@Lamb2006-uv]. 
It measures the similarities of expression signatures based on the enrichment of up- and 
down-regulated genes at the top and bottom of sorted (ranked) gene lists. 

## Query drug signatures

The following uses the 1,497 age-related gene expression signatures from Peters et al. 
[-@Peters2015-fc] as a query against the CMAP signatures. The results are sorted by the
ES Distance and the top scoring 20 drugs are given below. The full result table is  
written to a file named [`drugcmap2.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/drugcmap2.xls).


```r
library(DrugVsDisease)
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#", check.names=FALSE)
data(drugRL)
PMID26490707sub <- PMID26490707[PMID26490707[,"NEW-Gene-ID"] %in% rownames(drugRL),]
PMID26490707sub <- PMID26490707sub[order(PMID26490707sub$Zscore, decreasing=TRUE),]
PMID26490707sub <- rbind(head(PMID26490707sub, 100), tail(PMID26490707sub, 100)) # Subsets to top 200 DEGs 
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
drugcmap <- classifyprofile(data=testprofiles$ranklist, case="disease", signif.fdr=0.5, no.signif=20)
drugcmap2 <- classifyprofile(data=testprofiles$ranklist, case="disease", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=5, signif.fdr=5, adj="BH", no.signif=1000)
```

```
## Number of Significant results greater than 1000 Using top 1000 hits - consider using average linkage instead
```

```r
write.table(drugcmap2, file="./results/drugcmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
drugcmap2[[1]][1:20,]
```

```
##                              Drug ES Distance Cluster RPS
## dipivefrine           dipivefrine       0.660      62   1
## sulfathiazole       sulfathiazole       0.735      38   1
## fludroxycortide   fludroxycortide       0.740      95   1
## lobeline                 lobeline       0.740      38   1
## naftifine               naftifine       0.740      42  -1
## phenanthridinone phenanthridinone       0.750      99  -1
## ethoxyquin             ethoxyquin       0.755      27   1
## pentetrazol           pentetrazol       0.755      54   1
## fulvestrant           fulvestrant       0.765      22   1
## MS-275                     MS-275       0.770      84   1
## sirolimus               sirolimus       0.770      98   1
## physostigmine       physostigmine       0.775       1   1
## thiethylperazine thiethylperazine       0.775       1   1
## alvespimycin         alvespimycin       0.780      22   1
## naltrexone             naltrexone       0.780      78   1
## cimetidine             cimetidine       0.780      49   1
## acebutolol             acebutolol       0.785      58   1
## metolazone             metolazone       0.785      68   1
## troleandomycin     troleandomycin       0.785      45   1
## S-propranolol       S-propranolol       0.790      76   1
```

<div align="right">[Back to Table of Contents]()</div>

## Query disease signatures

The same query is performed against a reference set of disease expression signatures.
The results are sorted by the ES Distance and the top scoring 20 drugs are given below. 
The full result table is written to a file named [`diseasecmap2.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/diseasecmap2.xls).


```r
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#", check.names=FALSE)
data(diseaseRL)
PMID26490707sub <- PMID26490707[PMID26490707[,"NEW-Gene-ID"] %in% rownames(diseaseRL),]
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
diseasecmap <- classifyprofile(data=testprofiles$ranklist, case="drug", signif.fdr=0.5, no.signif=20)
```

```
## Number of Significant results greater than 20 Using top 20 hits - consider using average linkage instead
```

```r
diseasecmap2 <- classifyprofile(data=testprofiles$ranklist, case="drug", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=5, adj="BH", no.signif=100)
write.table(diseasecmap2, file="./results/diseasecmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
diseasecmap2[[1]][1:20,]
```

```
##                                                     Disease ES Distance Cluster RPS
## sarcoidosis                                     sarcoidosis   0.3630021       2   1
## sepsis                                               sepsis   0.4779160       5  -1
## aseptic-necrosis                           aseptic-necrosis   0.5624186       2   1
## inflammatory-bowel-disease       inflammatory-bowel-disease   0.5738416       2   1
## myelodysplastic-syndrome           myelodysplastic-syndrome   0.6118810       5  -1
## acute-nonlymphocytic-leukemia acute-nonlymphocytic-leukemia   0.6428131       2   1
## colorectal-cancer                         colorectal-cancer   0.6824003       3  -1
## small-cell-lung-cancer               small-cell-lung-cancer   0.7086938       4  -1
## periodontitis                                 periodontitis   0.7562997       1   1
## soft-tissue-sarcoma                     soft-tissue-sarcoma   0.7610299       4  -1
## schizophrenia                                 schizophrenia   0.7628188       6   1
## multiple-sclerosis                       multiple-sclerosis   0.7704229       5  -1
## juvenile-rheumatoid-arthritis juvenile-rheumatoid-arthritis   0.7825401       2   1
## interstitial-cystitis                 interstitial-cystitis   0.7862240       3   1
## osteoporosis                                   osteoporosis   0.7889821       5  -1
## ulcerative-colitis                       ulcerative-colitis   0.7930566       3   1
## parkinson-s-disease                     parkinson-s-disease   0.7952601       6   1
## mania                                                 mania   0.8068711       6   1
## prostate-cancer                             prostate-cancer   0.8263851       4  -1
## bladder-cancer                               bladder-cancer   0.8314094       4  -1
```

<div align="right">[Back to Table of Contents]()</div>

# Age-drug network analysis

In progress...

<div align="right">[Back to Table of Contents]()</div>

# Age-disease network analysis

In progress...

<div align="right">[Back to Table of Contents]()</div>

# Funding
This project is funded by NIH grant U24AG051129 awarded by the National Intitute on Aging (NIA).

<div align="right">[Back to Table of Contents]()</div>

# Version information


```r
sessionInfo()
```

```
## R version 3.2.2 (2015-08-14)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: CentOS Linux 7 (Core)
## 
## locale:
## [1] C
## 
## attached base packages:
## [1] parallel  stats     graphics  utils     datasets  grDevices methods   base     
## 
## other attached packages:
##  [1] DrugVsDisease_2.10.2    qvalue_2.2.2            cMap2data_1.6.0         DrugVsDiseasedata_1.6.0
##  [5] GEOquery_2.36.0         ArrayExpress_1.30.1     biomaRt_2.26.1          limma_3.26.5           
##  [9] affy_1.48.0             Biobase_2.30.0          BiocGenerics_0.16.1     ChemmineR_2.22.3       
## [13] reshape2_1.4.1          ggplot2_2.0.0           longevityTools_1.0.6    BiocStyle_1.8.0        
## 
## loaded via a namespace (and not attached):
##  [1] SummarizedExperiment_1.0.2 oligo_1.34.2               splines_3.2.2             
##  [4] colorspace_1.2-6           htmltools_0.3              stats4_3.2.2              
##  [7] yaml_2.1.13                XML_3.98-1.3               DBI_0.3.1                 
## [10] affyio_1.40.0              foreach_1.4.3              plyr_1.8.3                
## [13] stringr_1.0.0              zlibbioc_1.16.0            Biostrings_2.38.1         
## [16] munsell_0.4.3              gtable_0.1.2               codetools_0.2-14          
## [19] evaluate_0.8               labeling_0.3               knitr_1.12.3              
## [22] ff_2.2-13                  IRanges_2.4.3              BiocInstaller_1.20.1      
## [25] GenomeInfoDb_1.6.3         AnnotationDbi_1.32.3       preprocessCore_1.32.0     
## [28] Rcpp_0.12.3                scales_0.3.0               formatR_1.2.1             
## [31] S4Vectors_0.8.7            XVector_0.10.0             affxparser_1.42.0         
## [34] bit_1.1-12                 oligoClasses_1.32.0        rjson_0.2.15              
## [37] digest_0.6.9               stringi_1.0-1              GenomicRanges_1.22.1      
## [40] grid_3.2.2                 tools_3.2.2                bitops_1.0-6              
## [43] magrittr_1.5               RCurl_1.95-4.7             RSQLite_1.0.0             
## [46] rmarkdown_0.9.2            iterators_1.0.8
```
<div align="right">[Back to Table of Contents]()</div>

# References
