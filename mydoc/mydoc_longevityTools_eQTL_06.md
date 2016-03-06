---
title: Utilities
keywords: 
last_updated: Sun Mar  6 13:09:00 2016
---
The _`geneGrep`_ function takes GTEx results and gene list as arguments,
returns GTEx eSNP results for genes in gene list. Genes without significant
eSNPs are removed from results. The following sample file _Thyroid\_Analysis.snpgenes.TXNRD2_ has been subsetted to include eSNPs for TXNRD2.

{% highlight r %}
library(longevityTools)
samplepath <- system.file("extdata", "Thyroid_Analysis.snpgenes.TXNRD2", package="longevityTools") 
dat <- read.delim(samplepath)
myGenes <- c("TXNRD2")
result <- geneGrep(dat, myGenes)
head(result[order(result$p_value),])
{% endhighlight %}

{% highlight txt %}
##                    snp       beta      p_value ref alt gene_name   nom_thresh snp_chrom  snp_pos
## 83 22_19867771_C_T_b37 -0.4596489 6.598661e-21   C   T    TXNRD2 1.215557e-05        22 19867771
## 86 22_19868678_T_C_b37 -0.4522136 1.109763e-20   T   C    TXNRD2 1.215557e-05        22 19868678
## 82 22_19867276_T_C_b37 -0.4527145 5.145122e-20   T   C    TXNRD2 1.215557e-05        22 19867276
## 80 22_19866194_G_C_b37 -0.4547658 6.891885e-20   G   C    TXNRD2 1.215557e-05        22 19866194
## 95 22_19871691_C_T_b37 -0.4709824 8.145810e-20   C   T    TXNRD2 1.215557e-05        22 19871691
## 91 22_19870036_C_G_b37 -0.4454200 1.026483e-19   C   G    TXNRD2 1.215557e-05        22 19870036
##    snp_id_1kg_project_phaseI_v3 rs_id_dbSNP142_GRCh37p13
## 83                    rs1139795                rs1139795
## 86                   rs45465601               rs45465601
## 82                   rs34175429               rs34175429
## 80                    rs5993849                rs5993849
## 95                   rs12158214               rs12158214
## 91                    rs8141451                rs8141451
{% endhighlight %}

{% highlight r %}
#output results in PLINK format
result2<-result[,c("snp_id_1kg_project_phaseI_v3","p_value")]
names(result2)<-c("SNP","P")
#write.table(result2,file="data/eSNP.assoc",quote=F,row.names=F)
{% endhighlight %}

There are 139 eSNPs.

