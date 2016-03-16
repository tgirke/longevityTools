---
title: Getting Started
keywords: 
last_updated: Tue Mar 15 23:03:27 2016
---

## Installation

The R software for running [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


{% highlight r %}
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE) # Installs package from GitHub
{% endhighlight %}

## Loading of required packages


{% highlight r %}
library("longevityTools") 
library("ChemmineR") 
{% endhighlight %}


