---
title: Getting Started
keywords: 
last_updated: Wed May 25 17:08:15 2016
---

## Installation

The R software for running [_`longevityDrugs`_](https://github.com/tgirke/longevityDrugs) and [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


{% highlight r %}
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE, dependencies=FALSE) # Installs package from GitHub
biocLite("tgirke/longevityDrugs", build_vignettes=FALSE, dependencies=FALSE)
{% endhighlight %}

## Loading of required packages


{% highlight r %}
library(RSQLite); library(ChemmineR); library(longevityDrugs)
{% endhighlight %}

{% highlight txt %}
## Loading required package: DBI
{% endhighlight %}


