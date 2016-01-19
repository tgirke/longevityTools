# longevityTools
R package defining the analysis routines used by the [Longevity Genomics](http://www.longevitygenomics.org/) project funded by NIA. The HTML vignettes of the package are available here:

* [longevityDrugs](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools.html): overview vignette
* [longevityDrugs_eQTL](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eQTL.html): eQTL, eSNP and GWAS analysis
* [longevityDrugs_CMAP](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_CMAP.html): Connecting Drug- and Age-related Gene Expression Signatures

#### Installation 

```s
source("http://bioconductor.org/biocLite.R")
biocLite("tgirke/longevityTools", build_vignettes=TRUE, dependencies=TRUE)
```
