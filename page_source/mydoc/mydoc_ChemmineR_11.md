---
title: Working with SDF/SDFset Classes
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

Several methods are available to return the different data components of
`SDF/SDFset` containers in batches. The following
examples list the most important ones. To save space their content is
not printed in the manual. 

{% highlight r %}
 view(sdfset[1:4]) # Summary view of several molecules 

 length(sdfset) # Returns number of molecules 
 sdfset[[1]] # Returns single molecule from SDFset as SDF object 

 sdfset[[1]][[2]] # Returns atom block from first compound as matrix

 sdfset[[1]][[2]][1:4,] 
 c(sdfset[1:4], sdfset[5:8]) # Concatenation of several SDFsets 
{% endhighlight %}


The `grepSDFset` function allows string
matching/searching on the different data components in
`SDFset`. By default the function returns a SDF summary
of the matching entries. Alternatively, an index of the matches can be
returned with the setting `mode="index"`. 

{% highlight r %}
 grepSDFset("650001", sdfset, field="datablock", mode="subset") # To return index, set mode="index") 
{% endhighlight %}


Utilities to maintain unique compound IDs: 

{% highlight r %}
 sdfid(sdfset[1:4]) # Retrieves CMP IDs from Molecule Name field in header block. 
 cid(sdfset[1:4]) # Retrieves CMP IDs from ID slot in SDFset. 
 unique_ids <- makeUnique(sdfid(sdfset)) # Creates unique IDs by appending a counter to duplicates. 
 cid(sdfset) <- unique_ids # Assigns uniquified IDs to ID slot 
{% endhighlight %}


Subsetting by character, index and logical vectors: 

{% highlight r %}
 view(sdfset[c("650001", "650012")])
 view(sdfset[4:1])
 mylog <- cid(sdfset)
 view(sdfset[mylog]) 
{% endhighlight %}


Accessing `SDF/SDFset` components: header, atom, bond and
data blocks: 

{% highlight r %}
 atomblock(sdf); sdf[[2]];
 sdf[["atomblock"]] # All three methods return the same component

 header(sdfset[1:4]) 
 atomblock(sdfset[1:4])
 bondblock(sdfset[1:4]) 
 datablock(sdfset[1:4])  
 header(sdfset[[1]])
 atomblock(sdfset[[1]]) 
 bondblock(sdfset[[1]]) 
 datablock(sdfset[[1]]) 
{% endhighlight %}


Replacement Methods: 

{% highlight r %}
 sdfset[[1]][[2]][1,1] <- 999 
 atomblock(sdfset)[1] <- atomblock(sdfset)[2] 
 datablock(sdfset)[1] <- datablock(sdfset)[2] 
{% endhighlight %}


Assign matrix data to data block: 

{% highlight r %}
 datablock(sdfset) <- as.matrix(iris[1:100,])
 view(sdfset[1:4]) 
{% endhighlight %}


Class coercions from `SDFstr` to `list`,
`SDF` and `SDFset`: 

{% highlight r %}
 as(sdfstr[1:2], "list") as(sdfstr[[1]], "SDF")
 as(sdfstr[1:2], "SDFset") 
{% endhighlight %}


Class coercions from `SDF` to `SDFstr`,
`SDFset`, list with SDF sub-components: 

{% highlight r %}
 sdfcomplist <- as(sdf, "list") sdfcomplist <-
 as(sdfset[1:4], "list"); as(sdfcomplist[[1]], "SDF") sdflist <-
 as(sdfset[1:4], "SDF"); as(sdflist, "SDFset") as(sdfset[[1]], "SDFstr")
 as(sdfset[[1]], "SDFset") 
{% endhighlight %}


Class coercions from `SDFset` to lists with components
consisting of SDF or sub-components: 

{% highlight r %}
 as(sdfset[1:4], "SDF") as(sdfset[1:4], "list") as(sdfset[1:4], "SDFstr")
{% endhighlight %}


