---
title: Getting Started
keywords: 
last_updated: Thu Feb 11 21:16:00 2016
---

## Package install
To install an R package from GitHub, user want to open R in their favorite environemt
(_e.g._ [RStudio](https://www.rstudio.com/), [ESS](http://ess.r-project.org/)
or [VIM-R](http://manuals.bioinformatics.ucr.edu/home/programming-in-r/vim-r))
and then execute the following commands (here for [longevityTools](https://github.com/tgirke/longevityTools)) from the 
R console:

{% highlight s %}
source("http://bioconductor.org/biocLite.R")
biocLite("tgirke/longevityTools", build_vignettes=FALSE)
library(longevityTools)
{% endhighlight %}

## Finding help
Subsequently, the vignettes of the installed package can be opened in an
internet browser, from within RStudio or one can access them with this command:

{% highlight s %}
vignette(topic="longevityTools", package="longevityTools")
{% endhighlight %}

## Run workflows
Now, users want to follow the instructions given in the vignette (_e.g._
[longevityTools vignette](https://htmlpreview.github.io/?https://github.com/tgirke/longevityTools/blob/master/vignettes/longevityTools_eDRUG.html){:target="_blank"}).
To avoid typing and/or tedious copy&paste routines for executing code, users
should load the corresponding source file
([\*.R](https://raw.githubusercontent.com/tgirke/longevityTools/master/vignettes/longevityTools.R)
or [\*.Rmd](https://raw.githubusercontent.com/tgirke/longevityTools/master/vignettes/longevityTools.Rmd))
into their R working environment and then make use of built-in code sending or
sourcing functionalities. In addition, an entire workflow can be re-run with the
following command or by pushing the `built` button in RStudio, while the content in the corresponding vignette will be updated in real time. 
This includes all its text, code, tables, images and all results written to files.

{% highlight r %}
rmarkdown::render('longevityTools.Rmd'); Stangle("longevityTools.Rmd")
{% endhighlight %}

