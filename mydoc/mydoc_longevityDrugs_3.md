---
title: Load database
keywords: 
last_updated: Wed Mar 16 12:37:57 2016
---


{% highlight r %}
mypath <- system.file("extdata", "longevitydrugs.sdf", package="longevityTools")
sdfset <- read.SDFset(mypath)
data(sdfsample)
sdfsample
{% endhighlight %}

{% highlight txt %}
## An instance of "SDFset" with 100 molecules
{% endhighlight %}

{% highlight r %}
plot(sdfsample[1:4], print=FALSE)
{% endhighlight %}

![](longevityDrugs_files/load_sdf-1.png)


