---
title: Setup of working environment
keywords: 
last_updated: Wed Mar 16 12:35:34 2016
---

## Import custom functions 

Preliminary functions that are still under developement, or not fully tested and documented 
can be imported with the `source` command from the `inst/extdata` directory of the package.


{% highlight r %}
fctpath <- system.file("extdata", "longevityTools_eDRUG_Fct.R", package="longevityTools")
source(fctpath)
{% endhighlight %}

## Create expected directory structure 

The following creates the directory structure expected by this workflow. Input data
will be stored in the `data` directory and results will be written to the `results` directory.
All paths are given relative to the present working directory of the user's R session.


{% highlight r %}
dir.create("data"); dir.create("data/CEL"); dir.create("results") 
{% endhighlight %}


