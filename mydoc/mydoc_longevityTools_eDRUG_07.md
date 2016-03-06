---
title: Connectivity maps enrichment analysis
keywords: 
last_updated: Sun Mar  6 12:53:27 2016
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
testprofiles <- list(ranklist=matrix(PMID26490707sub$Zscore, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])), 
                     pvalues=matrix(PMID26490707sub$P, dimnames=list(PMID26490707sub[,"NEW-Gene-ID"])))
drugcmap <- classifyprofile(data=testprofiles$ranklist, case="disease", signif.fdr=0.5, no.signif=20)
drugcmap2 <- classifyprofile(data=testprofiles$ranklist, case="disease", 
                            pvalues=testprofiles$pvalues, cytoout=FALSE, type="dynamic", 
                            dynamic.fdr=0.5, signif.fdr=0.05, adj="BH", no.signif=100)
write.table(drugcmap2, file="./results/drugcmap2.xls", quote=FALSE, sep="\t", col.names = NA) 
drugcmap2[[1]][1:20,]
{% endhighlight %}

{% highlight txt %}
##                              Drug ES Distance Cluster RPS
## mebendazole           mebendazole   0.8322685      62   1
## cloperastine         cloperastine   0.8457056      98   1
## fenoterol               fenoterol   0.8467810      62   1
## (-)-isoprenaline (-)-isoprenaline   0.8476601      41   1
## (+)-chelidonine   (+)-chelidonine   0.8510637       1   1
## etacrynic_acid     etacrynic_acid   0.8514834     103   1
## oxedrine                 oxedrine   0.8561747      62   1
## suloctidil             suloctidil   0.8586264      93   1
## noscapine               noscapine   0.8595356      70   1
## trifluridine         trifluridine   0.8621584       4   1
## trifluoperazine   trifluoperazine   0.8624640      98   1
## etilefrine             etilefrine   0.8644660      40   1
## remoxipride           remoxipride   0.8655620      76   1
## etoposide               etoposide   0.8690638       4   1
## ethoxyquin             ethoxyquin   0.8695707      27   1
## albendazole           albendazole   0.8699840      93   1
## scoulerine             scoulerine   0.8705162       1   1
## bromopride             bromopride   0.8709264      91   1
## milrinone               milrinone   0.8712986      83   1
## terfenadine           terfenadine   0.8718878      93   1
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
                            dynamic.fdr=0.5, adj="BH", no.signif=100)
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


