---
title: Export of Compounds
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

## SDF Export

Write objects of classes `SDFset/SDFstr/SDF` to SD file:


{% highlight r %}
 write.SDF(sdfset[1:4], file="sub.sdf") 
{% endhighlight %}


Writing customized `SDFset` to file containing
`ChemmineR` signature, IDs from `SDFset`
and no data block: 

{% highlight r %}
 write.SDF(sdfset[1:4], file="sub.sdf", sig=TRUE, cid=TRUE, db=NULL) 
{% endhighlight %}


Example for injecting a custom matrix/data frame into the data block of
an `SDFset` and then writing it to an SD file:


{% highlight r %}
 props <- data.frame(MF=MF(sdfset), MW=MW(sdfset), atomcountMA(sdfset)) 
 datablock(sdfset) <- props
 write.SDF(sdfset[1:4], file="sub.sdf", sig=TRUE, cid=TRUE) 
{% endhighlight %}


Indirect export via `SDFstr` object: 

{% highlight r %}
 sdf2str(sdf=sdfset[[1]], sig=TRUE, cid=TRUE) # Uses default components 
 sdf2str(sdf=sdfset[[1]], head=letters[1:4], db=NULL) # Uses custom components for header and data block 
{% endhighlight %}


Write `SDF`, `SDFset` or
`SDFstr` classes to file: 

{% highlight r %}
 write.SDF(sdfset[1:4], file="sub.sdf", sig=TRUE, cid=TRUE, db=NULL)
 write.SDF(sdfstr[1:4], file="sub.sdf") 
 cat(unlist(as(sdfstr[1:4], "list")), file="sub.sdf", sep="") 
{% endhighlight %}


## SMILES Export

Write objects of class `SMIset` to SMILES file with and
without compound identifiers: 

{% highlight r %}
 data(smisample); smiset <- smisample # Sample data set 

 write.SMI(smiset[1:4], file="sub.smi", cid=TRUE) write.SMI(smiset[1:4], file="sub.smi", cid=FALSE) 
{% endhighlight %}


