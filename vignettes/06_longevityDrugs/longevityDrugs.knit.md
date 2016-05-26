---
title: "longevityDrugs: Database of Longevity-Associated Drugs (LAD)" 
author: "Authors: Thomas Girke, Tyler Backman, Dan Evans"
date: "Last update: 25 May, 2016" 
package: "longevityDrugs 1.0.0"
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
echo "rmarkdown::render('longevityDrugs.Rmd', clean=F)" | R -slave; R CMD Stangle longevityDrugs.Rmd

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
vignette can be found <a href="https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityDrugs.html">here</a>.

The data package `longevityDrugs` contains molecular structures and annotation information
of longevity-associated drugs (LADs). An iterative process will be used to assemble, update and 
curate this data set long-term [@Backman2011-uw; @Cao2008-zo]. Most small molecules will be identified by integrating several
large-scale community data sources such as data from drug databases (e.g.
Drugbank), bioassay databases (e.g. PubChem Bioassay, ChEMBL), literature,
drug-related gene expression fingerprints (e.g. LINCS), genetic (e.g. GWAS) and
phenotype resources. This will also include nearest neighbors of LADs sharing
with them structural, physicochemical or biological properties.


<div align="right">[Back to Table of Contents]()</div>


# Getting Started

## Installation

The R software for running [_`longevityDrugs`_](https://github.com/tgirke/longevityDrugs) and [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


```r
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE, dependencies=FALSE) # Installs package from GitHub
biocLite("tgirke/longevityDrugs", build_vignettes=FALSE, dependencies=FALSE)
```
<div align="right">[Back to Table of Contents]()</div>

## Loading of required packages


```r
library(RSQLite); library(ChemmineR); library(longevityDrugs)
```

```
## Loading required package: DBI
```

<div align="right">[Back to Table of Contents]()</div>

# Load database


```r
mypath <- system.file("extdata", "cmap.db", package="longevityDrugs")
conn <- initDb(mypath)
```


# Query database

## Retrieve compound structures

```r
results <- getAllCompoundIds(conn)
sdfset <- getCompounds(conn, results, keepOrder=TRUE)
sdfset
```

```
## An instance of "SDFset" with 1309 molecules
```

```r
plot(sdfset[1:4], print=FALSE)
```

![](longevityDrugs_files/figure-html/query_structures-1.png)<!-- -->

```r
as.data.frame(datablock2ma(datablock(sdfset)))[1:4,]
```

```
##     instance_id batch_id        cmap_name INN1 concentration..M. duration..h. cell2   array3
## 201           1        1        metformin  INN          1.00e-05            6  MCF7 HG-U133A
## 202          21        2       phenformin  INN          1.00e-05            6  MCF7 HG-U133A
## 203          22        2 phenyl biguanide               1.00e-05            6  MCF7 HG-U133A
## 204          23        2    valproic acid  INN          1.00e-03            6  MCF7 HG-U133A
##     perturbation_scan_id vehicle_scan_id4              scanner vehicle        vendor catalog_number
## 201       EC2003090503AA   EC2003090502AA HP GeneArray Scanner  medium Sigma-Aldrich          D5035
## 202       EC2003091104AA   EC2003091102AA HP GeneArray Scanner  medium Sigma-Aldrich          P7045
## 203       EC2003091105AA   EC2003091102AA HP GeneArray Scanner  medium Sigma-Aldrich         P19906
## 204       EC2003091106AA   EC2003091102AA HP GeneArray Scanner  medium Sigma-Aldrich          P4543
##                            catalog_name      SOURCE_DRUG     UNIPROT       P_SCORE DIRECTIONALITY
## 201 1,1-dimethylbiguanide hydrochloride        Metformin ZN396_HUMAN    1.53601286    Stimulatory
## 202            phenformin hydrochloride       Phenformin KI2L3_HUMAN   -6.33081681     Inhibitory
## 203     1-phenylbiguanide hydrochloride PHENYL BIGUANIDE  RHOC_HUMAN   -4.21084571     Inhibitory
## 204              2-propylpentanoic acid    Valproic Acid GSK3B_HUMAN  -58.47057966     Inhibitory
##     PUBCHEM_ID DRUGBANK_ID           DRUGBANK_GROUP        ATCCODES chembank_id   chembank_name
## 201    CID4091     DB00331                 approved A10BD11|A10BA02        1714       metformin
## 202    CID8249     DB00914       approved|withdrawn         A10BA01     1018627      phenformin
## 203    CID4780                                                            32656 phenylbiguanide
## 204    CID3121     DB00313 approved|investigational         N03AG01         471   valproic acid
##     match_distance                  smiles
## 201              0       CN(C)C(=N)NC(=N)N
## 202              0 NC(=N)NC(=N)NCCc1ccccc1
## 203              0   NC(=N)NC(=N)Nc1ccccc1
## 204              0         CCCC(CCC)C(=O)O
```

## Retrieve compound properties

```r
myfeat <- listFeatures(conn)
feat <- getCompoundFeatures(conn, results, myfeat)
feat[1:4,]
```

```
##   compound_id aromatic                  cansmi                cansmins  formula hba1 hba2 hbd
## 1         201        0       CN(C(=N)NC(=N)N)C       CN(C(=N)NC(=N)N)C  C4H11N5    5    5   4
## 2         202        1 N=C(NC(=N)N)NCCc1ccccc1 N=C(NC(=N)N)NCCc1ccccc1 C10H15N5    5    5   5
## 3         203        1   N=C(Nc1ccccc1)NC(=N)N   N=C(Nc1ccccc1)NC(=N)N  C8H11N5    5    5   5
## 4         204        0         CCCC(C(=O)O)CCC         CCCC(C(=O)O)CCC  C8H16O2    2    2   1
##                                                                                      inchi   logp
## 1                                  InChI=1S/C4H11N5/c1-9(2)4(7)8-3(5)6/h1-2H3,(H5,5,6,7,8) 0.2565
## 2 InChI=1S/C10H15N5/c11-9(12)15-10(13)14-7-6-8-4-2-1-3-5-8/h1-5H,6-7H2,(H6,11,12,13,14,15) 1.9181
## 3               InChI=1S/C8H11N5/c9-7(10)13-8(11)12-6-4-2-1-3-5-6/h1-5H,(H6,9,10,11,12,13) 1.8800
## 4                          InChI=1S/C8H16O2/c1-3-5-7(6-4-2)8(9)10/h7H,3-6H2,1-2H3,(H,9,10) 2.2874
##        mr       mw ncharges nf r2nh r3n rcch rcho rcn rcooh rcoor rcor rings rnh2 roh ropo3 ror
## 1 36.9285 129.1636        0  0    1   1    0    0   0     0     0    0     0    0   0     0   0
## 2 61.3212 205.2596        0  0    2   0    0    0   0     0     0    0     1    0   0     0   0
## 3 53.2452 177.2064        0  0    2   0    0    0   0     0     0    0     1    0   0     0   0
## 4 42.3418 144.2114        0  0    0   0    0    0   0     1     0    0     0    0   0     0   0
##              title  tpsa
## 1        metformin 88.99
## 2       phenformin 97.78
## 3 phenyl biguanide 97.78
## 4    valproic acid 37.30
```

<div align="right">[Back to Table of Contents]()</div>

# Funding
This project is funded by NIH grant U24AG051129 awarded by the National Intitute on Aging (NIA).

<div align="right">[Back to Table of Contents]()</div>

# Version information


```r
sessionInfo()
```

```
## R version 3.3.0 (2016-05-03)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 14.04.4 LTS
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
##  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
## [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  utils     datasets  grDevices methods   base     
## 
## other attached packages:
## [1] longevityDrugs_1.0.0 ChemmineR_2.24.2     RSQLite_1.0.0        DBI_0.4-1           
## [5] ggplot2_2.1.0        longevityTools_1.0.3 BiocStyle_2.0.2     
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.5      knitr_1.13       magrittr_1.5     munsell_0.4.3    colorspace_1.2-6
##  [6] rjson_0.2.15     stringr_1.0.0    plyr_1.8.3       tools_3.3.0      grid_3.3.0      
## [11] gtable_0.2.0     htmltools_0.3.5  yaml_2.1.13      digest_0.6.9     formatR_1.4     
## [16] bitops_1.0-6     codetools_0.2-14 RCurl_1.95-4.8   evaluate_0.9     rmarkdown_0.9.6 
## [21] stringi_1.0-1    scales_0.4.0
```
<div align="right">[Back to Table of Contents]()</div>

# References
