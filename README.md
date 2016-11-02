# longevityTools

[![Join the chat at https://gitter.im/tgirke/longevityTools](https://badges.gitter.im/tgirke/longevityTools.svg)](https://gitter.im/tgirke/longevityTools?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

R package defining the analysis routines used by the [Longevity Genomics](http://www.longevitygenomics.org/) project funded by NIA. The website of this GitHub project is available [here](http://girke.bioinformatics.ucr.edu/longevityTools). The HTML vignettes of the package are available here:

* [longevityTools](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools.html): overview vignette
* [longevityTools_eQTL](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eQTL.html): eQTL, eSNP and GWAS analysis
* [longevityTools_eDRUG](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eDRUG.html): connecting drug- and age-related gene expression signatures
* [longevityDrugs](https://github.com/tgirke/longevityDrugs): structures, properties and annotations of small molecules associated with longevity
* [longevityFeatures](https://github.com/tgirke/longevityFeatures): genes, proteins and other features associated with longevity and aging
* [SNPformat](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_SNPformat.html): SNP genotype data formatting

#### Installation 

```s
source("http://bioconductor.org/biocLite.R")
biocLite("tgirke/longevityTools", build_vignettes=FALSE, dependencies=FALSE)
```
