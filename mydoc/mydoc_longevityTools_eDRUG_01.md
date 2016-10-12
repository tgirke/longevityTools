---
title: longevityTools - Connecting Drug- and Age-related Gene Expression Signatures 
keywords: 
last_updated: Tue Oct 11 17:26:57 2016
---
Authors: Thomas Girke, Danjuma Quarless, Tyler Backman, Kuan-Fu Ding, Jamison McCorrison, Nik Schork, Dan Evans

Last update: 11 October, 2016 

Alternative formats of this vignette:
[`Single-page .Rmd HTML`](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eDRUG.html),
[`.Rmd`](https://raw.githubusercontent.com/tgirke/longevityTools/master/vignettes/longevityTools_eDRUG.Rmd),
[`.R`](https://raw.githubusercontent.com/tgirke/longevityTools/master/vignettes/longevityTools_eDRUG.R)

## Introduction 
This vignette is part of the NIA funded Longevity Genomics project. For more information on this project please visit its 
website [here](http://www.longevitygenomics.org/projects/). The GitHub repository of the corresponding R package 
is available <a href="https://github.com/tgirke/longevityTools">here</a> and the most recent version of this 
vignette can be found <a href="https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eDRUG.html">here</a>.

The project component covered by this vignette analyzes drug- and age-related
genome-wide expression data from public microarray and RNA-Seq experiments. One
of the main objective is the identification drug candidates modulating the
expression of longevity genes and pathways. For this, we compare age-related
expression signatures with those from drug treamtments. The age-related query
signatures are from recent publications such as Peters et al. (2015)
and Sood et al. (2015), while the drug-related reference signatures
are from the Connectivity Map (CMAP) and LINCS projects (Lamb et al., 2006).



