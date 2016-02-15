---
title: Searching PubChem
keywords: 
last_updated: Sat Feb 13 19:36:03 2016
---

## Get Compounds from PubChem by Id

The function `getIds` accepts one or more numeric PubChem
compound ids and downloads the corresponding compounds from PubChem
Power User Gateway (PUG) returning results in an `SDFset`
container. The ChemMine Tools web service is used as an intermediate, to
translate queries from plain HTTP POST to a PUG SOAP query.  

Fetch 2 compounds from PubChem:



{% highlight r %}
 compounds <- getIds(c(111,123))
 compounds 
{% endhighlight %}


## Search a SMILES Query in PubChem

The function `searchString` accepts one SMILES string
(Simplified Molecular Input Line Entry Specification) and performs a
\>0.95 similarity PubChem fingerprint search, returning the hits in an
`SDFset` container. The ChemMine Tools web service is
used as an intermediate, to translate queries from plain HTTP POST to a
PubChem Power User Gateway (PUG) query.  

Search a SMILES string on PubChem:



{% highlight r %}
 compounds <- searchString("CC(=O)OC1=CC=CC=C1C(=O)O") compounds 
{% endhighlight %}


## Search an SDF Query in PubChem

The function `searchSim` performs a PubChem similarity
search just like `searchString`, but accepts a query in
an `SDFset` container. If the query contains more than
one compound, only the first is searched.  

Search an `SDFset` container on PubChem:



{% highlight r %}
 data(sdfsample); 
 sdfset <- sdfsample[1] 
 compounds <- searchSim(sdfset) 
 compounds 
{% endhighlight %}


