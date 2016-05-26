---
title: longevityDrugs - Database of Longevity-Associated Drugs (LAD) 
keywords: 
last_updated: Wed May 25 17:08:15 2016
---
Authors: Thomas Girke, Tyler Backman, Dan Evans

Last update: 25 May, 2016 

Alternative formats of this vignette:
[`Single-page .Rmd HTML`](https://htmlpreview.github.io/?https://github.com/tgirke/longevityDrugs/blob/master/vignettes/longevityDrugs.html),
[`.Rmd`](https://raw.githubusercontent.com/tgirke/longevityDrugs/master/vignettes/longevityDrugs.Rmd),
[`.R`](https://raw.githubusercontent.com/tgirke/longevityDrugs/master/vignettes/longevityDrugs.R)

## Introduction 
This vignette is part of the NIA funded Longevity Genomics project. For more information on this project please visit its 
website [here](http://www.longevitygenomics.org/projects/). The GitHub repository of the corresponding R package 
is available <a href="https://github.com/tgirke/longevityTools">here</a> and the most recent version of this 
vignette can be found <a href="https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityDrugs.html">here</a>.

The data package `longevityDrugs` contains molecular structures and annotation information
of longevity-associated drugs (LADs). An iterative process will be used to assemble, update and 
curate this data set long-term (Backman et al., 2011; Cao et al., 2008). Most small molecules will be identified by integrating several
large-scale community data sources such as data from drug databases (e.g.
Drugbank), bioassay databases (e.g. PubChem Bioassay, ChEMBL), literature,
drug-related gene expression fingerprints (e.g. LINCS), genetic (e.g. GWAS) and
phenotype resources. This will also include nearest neighbors of LADs sharing
with them structural, physicochemical or biological properties.




