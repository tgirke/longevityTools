---
title: Query database
keywords: 
last_updated: Wed May 25 17:04:12 2016
---

## Retrieve compound structures
{% highlight txt %}
results <- getAllCompoundIds(conn)
sdfset <- getCompounds(conn, results, keepOrder=TRUE)
sdfset
plot(sdfset[1:4], print=FALSE)
as.data.frame(datablock2ma(datablock(sdfset)))[1:4,]
{% endhighlight %}

## Retrieve compound properties
{% highlight txt %}
myfeat <- listFeatures(conn)
feat <- getCompoundFeatures(conn, results, myfeat)
feat[1:4,]
{% endhighlight %}


