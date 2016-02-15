---
title: Installation of R and Add-on Packages
keywords: 
last_updated: Thu Feb 11 21:16:00 2016
---

1. Install R for your operating system from [CRAN](http://cran.at.r-project.org/).

2. Install RStudio from [RStudio](http://www.rstudio.com/ide/download).

3. Install CRAN Packages from R console like this:


{% highlight r %}
install.packages(c("pkg1", "pkg2")) 
install.packages("pkg.zip", repos=NULL)
{% endhighlight %}

4. Install Bioconductor packages as follows:


{% highlight r %}
source("http://www.bioconductor.org/biocLite.R")
library(BiocInstaller)
BiocVersion()
biocLite()
biocLite(c("pkg1", "pkg2"))
{% endhighlight %}

5. For more details consult the [Bioc Install page](http://www.bioconductor.org/install/)
and [BiocInstaller](http://www.bioconductor.org/packages/release/bioc/html/BiocInstaller.html) package.

