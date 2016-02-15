---
title: Import of Compounds
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

## SDF Import

The following gives an overview of the most important import/export
functionalities for small molecules provided by
`ChemmineR`. The given example creates an instance of the
`SDFset` class using as sample data set the first 100
compounds from this PubChem SD file (SDF):
Compound\_00650001\_00675000.sdf.gz
(<ftp://ftp.ncbi.nih.gov/pubchem/Compound/CURRENT-Full/SDF/>).  

SDFs can be imported with the `read.SDFset` function:


{% highlight r %}
 sdfset <- read.SDFset("http://faculty.ucr.edu/ tgirke/Documents/R_BioCond/Samples/sdfsample.sdf") 
{% endhighlight %}


{% highlight r %}
 data(sdfsample) # Loads the same SDFset provided by the library 
 sdfset <- sdfsample
 valid <- validSDF(sdfset) # Identifies invalid SDFs in SDFset objects 
 sdfset <- sdfset[valid] # Removes invalid SDFs, if there are any 
{% endhighlight %}


Import SD file into `SDFstr` container: 

{% highlight r %}
 sdfstr <- read.SDFstr("http://faculty.ucr.edu/ tgirke/Documents/R_BioCond/Samples/sdfsample.sdf") 
{% endhighlight %}
Create
`SDFset` from `SDFstr` class:


{% highlight r %}
 sdfstr <- as(sdfset, "SDFstr") 
 sdfstr
{% endhighlight %}

{% highlight txt %}
## An instance of "SDFstr" with 100 molecules
{% endhighlight %}

{% highlight r %}
 as(sdfstr, "SDFset") 
{% endhighlight %}

{% highlight txt %}
## An instance of "SDFset" with 100 molecules
{% endhighlight %}


## SMILES Import

The `read.SMIset` function imports one or many molecules
from a SMILES file and stores them in a `SMIset`
container. The input file is expected to contain one SMILES string per
row with tab-separated compound identifiers at the end of each line. The
compound identifiers are optional.  

Create sample SMILES file and then import it: 

{% highlight r %}
 data(smisample); smiset <- smisample
 write.SMI(smiset[1:4], file="sub.smi") 
 smiset <- read.SMIset("sub.smi")
{% endhighlight %}


Inspect content of `SMIset`: 

{% highlight r %}
 data(smisample) # Loads the same SMIset provided by the library 
 smiset <- smisample
 smiset 
{% endhighlight %}

{% highlight txt %}
## An instance of "SMIset" with 100 molecules
{% endhighlight %}

{% highlight r %}
 view(smiset[1:2]) 
{% endhighlight %}

{% highlight txt %}
## $`650001`
## An instance of "SMI"
## [1] "O=C(NC1CCCC1)CN(c1cc2OCCOc2cc1)C(=O)CCC(=O)Nc1noc(c1)C"
## 
## $`650002`
## An instance of "SMI"
## [1] "O=c1[nH]c(=O)n(c2nc(n(CCCc3ccccc3)c12)NCCCO)C"
{% endhighlight %}


Accessor functions: 

{% highlight r %}
 cid(smiset[1:4]) 
{% endhighlight %}

{% highlight txt %}
## [1] "650001" "650002" "650003" "650004"
{% endhighlight %}

{% highlight r %}
 smi <- as.character(smiset[1:2])
{% endhighlight %}


Create `SMIset` from named character vector:


{% highlight r %}
 as(smi, "SMIset") 
{% endhighlight %}

{% highlight txt %}
## An instance of "SMIset" with 2 molecules
{% endhighlight %}


