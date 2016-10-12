---
title: Connectivity maps enrichment analysis
keywords: 
last_updated: Tue Oct 11 17:26:57 2016
---

The connectivity maps approach is a rank-based enrichment method utilizing the KS test (Lamb et al., 2006). 
It measures the similarities of expression signatures based on the enrichment of up- and 
down-regulated genes at the top and bottom of sorted (ranked) gene lists. 

## Query drug signatures

The following uses the 1,497 age-related gene expression signatures from Peters et al. 
(2015) as a query against the CMAP signatures. The results are sorted by the
ES Distance and the top scoring 20 drugs are given below. The full result table is  
written to a file named [`drugcmap2.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/drugcmap2.xls).


{% highlight r %}
library(DrugVsDisease)
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#", check.names=FALSE)
data(drugRL)
PMID26490707sub <- PMID26490707[PMID26490707[,"NEW-Gene-ID"] %in% rownames(drugRL),]
PMID26490707sub <- PMID26490707sub[order(PMID26490707sub$Zscore, decreasing=TRUE),]
PMID26490707sub <- rbind(head(PMID26490707sub, 100), tail(PMID26490707sub, 100)) # Subsets to top 200 DEGs 
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
drugcmap <- classifyprofile(data=testprofiles$ranklist, case="disease", signif.fdr=0.5, no.signif=20)
drugcmap2 <- classifyprofile(data=testprofiles$ranklist, case="disease", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=5, signif.fdr=5, adj="BH", no.signif=1000)
{% endhighlight %}

{% highlight txt %}
## Number of Significant results greater than 1000 Using top 1000 hits - consider using average linkage instead
{% endhighlight %}

{% highlight r %}
write.table(drugcmap2, file="./results/drugcmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
drugcmap2[[1]][1:20,]
{% endhighlight %}

{% highlight txt %}
##                              Drug ES Distance Cluster RPS
## dipivefrine           dipivefrine       0.660      62   1
## sulfathiazole       sulfathiazole       0.735      38   1
## fludroxycortide   fludroxycortide       0.740      95   1
## lobeline                 lobeline       0.740      38   1
## naftifine               naftifine       0.740      42  -1
## phenanthridinone phenanthridinone       0.750      99  -1
## ethoxyquin             ethoxyquin       0.755      27   1
## pentetrazol           pentetrazol       0.755      54   1
## fulvestrant           fulvestrant       0.765      22   1
## MS-275                     MS-275       0.770      84   1
## sirolimus               sirolimus       0.770      98   1
## physostigmine       physostigmine       0.775       1   1
## thiethylperazine thiethylperazine       0.775       1   1
## alvespimycin         alvespimycin       0.780      22   1
## naltrexone             naltrexone       0.780      78   1
## cimetidine             cimetidine       0.780      49   1
## acebutolol             acebutolol       0.785      58   1
## metolazone             metolazone       0.785      68   1
## troleandomycin     troleandomycin       0.785      45   1
## S-propranolol       S-propranolol       0.790      76   1
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
{% endhighlight %}

{% highlight txt %}
## Number of Significant results greater than 20 Using top 20 hits - consider using average linkage instead
{% endhighlight %}

{% highlight r %}
diseasecmap2 <- classifyprofile(data=testprofiles$ranklist, case="drug", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=5, adj="BH", no.signif=100)
write.table(diseasecmap2, file="./results/diseasecmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
diseasecmap2[[1]][1:20,]
{% endhighlight %}

{% highlight txt %}
##                                                     Disease ES Distance Cluster RPS
## sarcoidosis                                     sarcoidosis   0.3630021       2   1
## sepsis                                               sepsis   0.4779160       5  -1
## aseptic-necrosis                           aseptic-necrosis   0.5624186       2   1
## inflammatory-bowel-disease       inflammatory-bowel-disease   0.5738416       2   1
## myelodysplastic-syndrome           myelodysplastic-syndrome   0.6118810       5  -1
## acute-nonlymphocytic-leukemia acute-nonlymphocytic-leukemia   0.6428131       2   1
## colorectal-cancer                         colorectal-cancer   0.6824003       3  -1
## small-cell-lung-cancer               small-cell-lung-cancer   0.7086938       4  -1
## periodontitis                                 periodontitis   0.7562997       1   1
## soft-tissue-sarcoma                     soft-tissue-sarcoma   0.7610299       4  -1
## schizophrenia                                 schizophrenia   0.7628188       6   1
## multiple-sclerosis                       multiple-sclerosis   0.7704229       5  -1
## juvenile-rheumatoid-arthritis juvenile-rheumatoid-arthritis   0.7825401       2   1
## interstitial-cystitis                 interstitial-cystitis   0.7862240       3   1
## osteoporosis                                   osteoporosis   0.7889821       5  -1
## ulcerative-colitis                       ulcerative-colitis   0.7930566       3   1
## parkinson-s-disease                     parkinson-s-disease   0.7952601       6   1
## mania                                                 mania   0.8068711       6   1
## prostate-cancer                             prostate-cancer   0.8263851       4  -1
## bladder-cancer                               bladder-cancer   0.8314094       4  -1
{% endhighlight %}


