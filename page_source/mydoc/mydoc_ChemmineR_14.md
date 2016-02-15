---
title: Charges and Missing Hydrogens
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

The function `bonds` returns information about the number
of bonds, charges and missing hydrogens in `SDF` and
`SDFset` objects. It is used by many other functions
(*e.g.* `MW`, `MF`,
`atomcount`, `atomcuntMA` and
`plot`) to correct for missing hydrogens that are often
not specified in SD files. 

{% highlight r %}
 bonds(sdfset[[1]], type="bonds")[1:4,]
{% endhighlight %}

{% highlight txt %}
##   atom Nbondcount Nbondrule charge
## 1    O          2         2      0
## 2    O          2         2      0
## 3    O          2         2      0
## 4    O          2         2      0
{% endhighlight %}

{% highlight r %}
 bonds(sdfset[1:2], type="charge")
{% endhighlight %}

{% highlight txt %}
## $CMP1
## NULL
## 
## $CMP2
## NULL
{% endhighlight %}

{% highlight r %}
 bonds(sdfset[1:2], type="addNH") 
{% endhighlight %}

{% highlight txt %}
## CMP1 CMP2 
##    0    0
{% endhighlight %}


