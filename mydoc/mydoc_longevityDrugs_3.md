---
title: Load database
keywords: 
last_updated: Wed May 25 17:08:15 2016
---


{% highlight r %}
mypath <- system.file("extdata", "cmap.db", package="longevityDrugs")
conn <- initDb(mypath)
{% endhighlight %}


