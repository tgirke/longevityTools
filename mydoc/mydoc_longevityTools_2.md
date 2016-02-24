---
title: Getting Started
keywords: 
last_updated: Wed Feb 24 13:37:47 2016
---

## Installation

The R software for running [_`longevityTools`_](https://github.com/tgirke/longevityTools) can be downloaded from [_CRAN_](http://cran.at.r-project.org/). The _`longevityTools`_ package can be installed from the R console using the following _`biocLite`_ install command. 


{% highlight r %}
source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script 
biocLite("tgirke/longevityTools", build_vignettes=FALSE, dependencies=FALSE) # Installs package from GitHub
{% endhighlight %}

## Loading package and documentation


{% highlight r %}
library("longevityTools") # Loads the package
library(help="longevityTools") # Lists package info
vignette("longevityTools") # Opens vignette
{% endhighlight %}


## GitHub workflow


{% highlight sh %}
git clone git@github.com:tgirke/longevityTools.git
cd longevityTools
git pull # Get updates from remote
git branch # Check whether you are in the master branch 
## do some work, commit/push changes to local and remote ##
git commit -am "some edits"; git push -u origin master
{% endhighlight %}


