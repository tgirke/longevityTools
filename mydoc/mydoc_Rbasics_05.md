---
title: Getting Around
keywords: 
last_updated: Thu Feb 11 21:16:00 2016
---

## Startup and Closing Behavior

* __Starting R__:
    The R GUI versions, including RStudio, under Windows and Mac OS X can be
    opened by double-clicking their icons. Alternatively, one can start it by
    typing `R` in a terminal (default under Linux). 

* __Startup/Closing Behavior__:
    The R environment is controlled by hidden files in the startup directory:
    `.RData`, `.Rhistory` and `.Rprofile` (optional). 
	
    
* __Closing R__:

    
    ```r
    q()  
    Save workspace image? [y/n/c]:
    ```
        
* __Note__:
    When responding with `y`, then the entire R workspace will be written to
    the `.RData` file which can become very large. Often it is sufficient to just
    save an analysis protocol in an R source file. This way one can quickly
    regenerate all data sets and objects. 


## Navigating directories

Create an object with the assignment operator `<-` or `=`

{% highlight r %}
object <- ...
{% endhighlight %}

List objects in current R session

{% highlight r %}
ls()
{% endhighlight %}

Return content of current working directory

{% highlight r %}
dir()
{% endhighlight %}

Return path of current working directory

{% highlight r %}
getwd()
{% endhighlight %}

Change current working directory

{% highlight r %}
setwd("/home/user")
{% endhighlight %}

