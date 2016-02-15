---
title: Connectivity maps enrichment analysis
keywords: 
last_updated: Mon Feb 15 15:06:28 2016
---

The connectivity maps approach is a rank-based enrichment method utilizing the KS test [@Lamb2006-uv]. 
It measures the similarities of expression signatures based on the enrichment of up- and 
down-regulated genes at the top and bottom of sorted (ranked) gene lists. 

## Query drug signatures

The following uses the 1,497 age-related gene expression signatures from Peters et al. 
[-@Peters2015-fc] as a query against the CMAP signatures. The results are sorted by the
ES Distance and the top scoring 20 drugs are given below. The full result table is  
written to a file named [`drugcmap2.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/drugcmap2.xls).


{% highlight r %}
library(DrugVsDisease)
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#", check.names=FALSE)
data(drugRL)
PMID26490707sub <- PMID26490707[PMID26490707[,"NEW-Gene-ID"] %in% rownames(drugRL),]
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
drugcmap <- classifyprofile(data=testprofiles$ranklist, case="disease", signif.fdr=0.5, no.signif=20)
drugcmap2 <- classifyprofile(data=testprofiles$ranklist, case="disease", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=0.5, signif.fdr=0.05, adj="BH", no.signif=100)
write.table(drugcmap2, file="./results/drugcmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
drugcmap2[[1]][1:20,]
{% endhighlight %}


## Query disease signatures

The same query is performed against a reference set of disease expression signatures.
The results are sorted by the ES Distance and the top scoring 20 drugs are given below. 
The full result table is written to a file named [`diseasecmap2.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/diseasecmap2.xls).


{% highlight r %}
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#", check.names=FALSE)
data(diseaseRL)
PMID26490707sub <- PMID26490707[PMID26490707[,"NEW-Gene-ID"] %in% rownames(diseaseRL),]
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
diseasecmap <- classifyprofile(data=testprofiles$ranklist, case="drug", signif.fdr=0.5, no.signif=20)
diseasecmap2 <- classifyprofile(data=testprofiles$ranklist, case="drug", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=0.5, adj="BH", no.signif=100)
write.table(diseasecmap2, file="./results/diseasecmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
diseasecmap2[[1]][1:20,]
{% endhighlight %}


