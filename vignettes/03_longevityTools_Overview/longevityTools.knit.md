---
title: "longevityToolsOverview - Analysis Tools for Longevity Research" 
author: "Authors: Thomas Girke, Danjuma Quarless, Tyler Backman, Kuan-Fu Ding, Jamison McCorrison, Nik Schork, Dan Evans"
date: "Last update: 24 February, 2016" 
package: "longevityTools 1.0.0"
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
echo "rmarkdown::render('longevityTools.Rmd', clean=F)" | R -slave; R CMD Stangle longevityTools.Rmd; Rscript ../md2jekyll.R longevityTools.knit.md 8

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
vignette can be found <a href="https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools.html">here</a>.

This overview tutorial provides general information about the `longevityTools` package.
This includes an introduction into the objects, data structures, methods and
functions defined by `longevityTools`. The development of `longevityTools` is part of the 
[Longevity Genomics](http://www.longevitygenomics.org/) project. 
The analysis workflows used by this project are documented in its companion vignettes listed below.

<div align="right">[Back to Table of Contents]()</div>


# Getting Started

## Installation

The R software for running [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


```r
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE, dependencies=FALSE) # Installs package from GitHub
```
<div align="right">[Back to Table of Contents]()</div>

## Loading package and documentation


```r
library("longevityTools") # Loads the package
library(help="longevityTools") # Lists package info
vignette("longevityTools") # Opens vignette
```

<div align="right">[Back to Table of Contents]()</div>

## GitHub workflow


```sh
git clone git@github.com:tgirke/longevityTools.git
cd longevityTools
git pull # Get updates from remote
git branch # Check whether you are in the master branch 
## do some work, commit/push changes to local and remote ##
git commit -am "some edits"; git push -u origin master
```

<div align="right">[Back to Table of Contents]()</div>

# Overview of object clases, methods and functions

To be continued... [@Lamb2006-uv; @Peters2015-fc; @Sood2015-pb].

<div align="right">[Back to Table of Contents]()</div>

# Workflow vignettes

Currently, this package includes the following analysis workflow vignettes:

* [longevityTools](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools.html): overview vignette
* [longevityTools_eQTL](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eQTL.html): eQTL, eSNP and GWAS analysis
* [longevityTools_eDRUG](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eDRUG.html): connecting drug- and age-related gene expression signatures
* longevityTools_Drugs: coming soon

<div align="right">[Back to Table of Contents]()</div>

# Funding
This project is funded by NIH grant U24AG051129 awarded by the National Intitute on Aging (NIA).

<div align="right">[Back to Table of Contents]()</div>

# Version information


```r
sessionInfo()
```

```
## R version 3.2.3 (2015-12-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 14.04.3 LTS
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
## [1] ggplot2_2.0.0        longevityTools_1.0.3 BiocStyle_1.8.0     
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.3      codetools_0.2-14 digest_0.6.9     plyr_1.8.3       grid_3.2.3      
##  [6] gtable_0.1.2     formatR_1.2.1    magrittr_1.5     evaluate_0.8     scales_0.3.0    
## [11] stringi_1.0-1    rmarkdown_0.9.2  tools_3.2.3      stringr_1.0.0    munsell_0.4.2   
## [16] yaml_2.1.13      colorspace_1.2-6 htmltools_0.3    knitr_1.12
```
<div align="right">[Back to Table of Contents]()</div>

# References
