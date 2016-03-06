---
title: SNP clumping using PLINK
keywords: 
last_updated: Sun Mar  6 13:09:00 2016
---
GTEx V6 analysis results are based on genotypes imputed to 1000 Genomes (1KG) Phase I version 3. Thus, significant results could be LD-filtered using Phase I data. However, to make use of the larger sample size in later projects, 1KG Phase 3 genotypes will be used.


{% highlight r %}
#genotypes
download.file("ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz", "./ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz")
untar("ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz")

#sample ped file
download.file("ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v2.20130502.ALL.ped", "./integrated_call_samples_v2.20130502.ALL.ped")

#sample super population file
download.file("ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel", "./integrated_call_samples_v3.20130502.ALL.panel")

#identify EUR unrelated samples from 1KG phase 3
ped2<-read.table("data/integrated_call_samples_v2.20130502.ALL.ped", stringsAsFactors = F, header = T, sep="\t")
ped3<-read.table("data/integrated_call_samples_v3.20130502.ALL.panel", stringsAsFactors = F, header = T, sep="\t")

samples1KG <- filter_1KGsamples("EUR",ped2,ped3)
samples1KG_ID <- samples1KG[,"Individual.ID",drop=F]
write.table(samples1KG_ID,file="data/samples1KG.txt",quote=F,row.names=F,col.names=F)
{% endhighlight %}

Create region file to use with bcftools for LD.

{% highlight r %}
regions<-data.frame(chr="chr1",pos=0,pos_to=0,stringsAsFactors = F)
regions$chr[1]<-gsub("chr","",result$snp_chrom[1]) #1KG genotype files do not have chr
regions$pos[1]<-min(result$snp_pos)
regions$pos_to[1]<-max(result$snp_pos)
write.table(regions,file="data/regions.txt",quote=F,row.names=F,col.names=F,sep="\t")
{% endhighlight %}


Filter 1KG genotypes to only include EUR unrelated individuals and eQTL region.
{% highlight txt %}
>bcftools --version
bcftools 1.3
Using htslib 1.3
Copyright (C) 2015 Genome Research Ltd.
License Expat: The MIT/Expat license
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

{% endhighlight %}

{% highlight txt %}
bcftools view -Ov -o results/1KGgeno.vcf -S data/samples1KG.txt -R data/regions.txt -v snps data/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
#without -v snps, multiple indels with same rsID were outputted, and plink would not read that in.
#Quick solution, only include SNPs, not indels.
{% endhighlight %}

Run PLINK clump command using default settings, but might want to change with different nominal significance thresholds.

{% highlight txt %}
plink -vcf results/1KGgeno.vcf --clump data/eSNP.assoc 

{% endhighlight %}

PLINK clump command identifies 8 independent eSNPs in the region. 

Next step, extract independent eSNPs from individual level genotype data, build MR risk score, evaluate for association with survival time.


