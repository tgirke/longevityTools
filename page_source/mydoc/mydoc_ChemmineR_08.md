---
title: Splitting SD Files
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

The following `write.SDFsplit` function allows to split
SD Files into any number of smaller SD Files. This can become important
when working with very big SD Files. Users should note that this
function can output many files, thus one should run it in a dedicated
directory!  

Create sample SD File with 100 molecules: 

{% highlight r %}
 write.SDF(sdfset, "test.sdf") 
{% endhighlight %}


Read in sample SD File. Note: reading file into SDFstr is much faster
than into SDFset: 

{% highlight r %}
 sdfstr <- read.SDFstr("test.sdf") 
{% endhighlight %}


Run export on `SDFstr` object: 

{% highlight r %}
 write.SDFsplit(x=sdfstr, filetag="myfile", nmol=10) # 'nmol' defines the number of molecules to write to each file 
{% endhighlight %}


Run export on `SDFset` object: 

{% highlight r %}
 write.SDFsplit(x=sdfset, filetag="myfile", nmol=10) 
{% endhighlight %}


