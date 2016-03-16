---
title: "longevityDrugs: Database of Longevity-Associated Drugs (LAD)" 
author: "Authors: Thomas Girke, Tyler Backman, Dan Evans"
date: "Last update: 15 March, 2016" 
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
curate this data set long-term [@Backman2011-uw, Cao2008-zo]. Most small molecules will be identified by integrating several
large-scale community data sources such as data from drug databases (e.g.
Drugbank), bioassay databases (e.g. PubChem Bioassay, ChEMBL), literature,
drug-related gene expression fingerprints (e.g. LINCS), genetic (e.g. GWAS) and
phenotype resources. This will also include nearest neighbors of LADs sharing
with them structural, physicochemical or biological properties.


<div align="right">[Back to Table of Contents]()</div>


# Getting Started

## Installation

The R software for running [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


```r
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE) # Installs package from GitHub
```
<div align="right">[Back to Table of Contents]()</div>

## Loading of required packages


```r
library("longevityTools") 
library("ChemmineR") 
```

<div align="right">[Back to Table of Contents]()</div>

# Load database


```r
sdfset <- read.SDFset("inst/ext/longevityDrugs.sdf")
plot(sdfset)
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
## R version 3.2.2 (2015-08-14)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: CentOS Linux 7 (Core)
## 
## locale:
## [1] C
## 
## attached base packages:
## [1] stats     graphics  utils     datasets  grDevices methods   base     
## 
## other attached packages:
## [1] ggplot2_2.0.0        longevityTools_1.0.4 BiocStyle_1.8.0     
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.3      codetools_0.2-14 digest_0.6.9     plyr_1.8.3       grid_3.2.2      
##  [6] gtable_0.1.2     formatR_1.2.1    magrittr_1.5     evaluate_0.8     scales_0.3.0    
## [11] stringi_1.0-1    rmarkdown_0.9.2  tools_3.2.2      stringr_1.0.0    munsell_0.4.3   
## [16] yaml_2.1.13      colorspace_1.2-6 htmltools_0.3    knitr_1.12.3
```
<div align="right">[Back to Table of Contents]()</div>

# References
