---
title: Basic Syntax
keywords: 
last_updated: Fri Feb 12 18:06:43 2016
---

General R command syntax


{% highlight r %}
object <- function_name(arguments) 
object <- object[arguments] 
{% endhighlight %}

Finding help


{% highlight r %}
?function_name
{% endhighlight %}

Load a library/package


{% highlight r %}
library("my_library") 
{% endhighlight %}

List functions defined by a library


{% highlight r %}
library(help="my_library")
{% endhighlight %}

Load library manual (PDF or HTML file)


{% highlight r %}
vignette("my_library") 
{% endhighlight %}

Execute an R script from within R


{% highlight r %}
source("my_script.R")
{% endhighlight %}

Execute an R script from command-line (the first of the three options is preferred)


{% highlight sh %}
$ Rscript my_script.R
$ R CMD BATCH my_script.R 
$ R --slave < my_script.R 
{% endhighlight %}

