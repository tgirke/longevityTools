---
title: Getting Started
keywords: 
last_updated: Sun Mar  6 12:53:27 2016
---

## Installation

The R software for running [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


{% highlight r %}
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE) # Installs package from GitHub
{% endhighlight %}

## Loading package and documentation


{% highlight r %}
library("longevityTools") # Loads the package
library(help="longevityTools") # Lists package info
vignette(topic="longevityTools_eDRUG", package="longevityTools") # Opens vignette
{% endhighlight %}

