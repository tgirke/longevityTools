---
title: Bond Matrices
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

Bond matrices provide an efficient data structure for many basic
computations on small molecules. The function `conMA`
creates this data structure from `SDF` and
`SDFset` objects. The resulting bond matrix contains the
atom labels in the row/column titles and the bond types in the data
part. The labels are defined as follows: 0 is no connection, 1 is a
single bond, 2 is a double bond and 3 is a triple bond. 

{% highlight r %}
 conMA(sdfset[1:2],
 exclude=c("H")) # Create bond matrix for first two molecules in sdfset

 conMA(sdfset[[1]], exclude=c("H")) # Return bond matrix for first molecule 
 plot(sdfset[1], atomnum = TRUE, noHbonds=FALSE , no_print_atoms = "", atomcex=0.8) # Plot its structure with atom numbering 
 rowSums(conMA(sdfset[[1]], exclude=c("H"))) # Return number of non-H bonds for each atom
{% endhighlight %}


