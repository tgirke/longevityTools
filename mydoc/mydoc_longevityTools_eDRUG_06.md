---
title: DEG analysis with `limma`
keywords: 
last_updated: Mon Feb 15 15:06:28 2016
---

## Generate list of CEL names defining treatment vs. control comparisons

The `sampleList` function extracts the sample comparisons (contrasts) from the
CMAP annotation table and stores them as a list.


{% highlight r %}
cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE) 
# comp_list <- sampleList(cmap, myby="CMP")
comp_list <- sampleList(cmap, myby="CMP_CELL")
{% endhighlight %}


## Load normalized expression data 

The following loads the MAS5 normalized expression data into a single `data.frame`. 
To accelerate the import, the data is read from `rds` files. 


{% highlight r %}
chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
df1 <- readRDS(paste0("data/", chiptype_dir[1], "/", "all_mas5exprs.rds"))
df2 <- readRDS(paste0("data/", chiptype_dir[2], "/", "all_mas5exprs.rds"))
df3 <- readRDS(paste0("data/", chiptype_dir[3], "/", "all_mas5exprs.rds"))
affyid <- rownames(df1)[rownames(df1) %in% rownames(df2)]; affyid <- affyid[affyid %in% rownames(df3)]
mas5df <- cbind(df1[affyid,], df2[affyid,], df3[affyid,])
{% endhighlight %}


## DEG analysis with `limma`

The analysis of differentially expressed genes (DEGs) is performed with the `limma` package.
Genes meeting the chosen cutoff criteria are reported as DEGs (below set to FDR of 10% and 
a minimum fold change of 2). The DEG matrix is written to a file named 
[`degMA.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/degMA.xls).


{% highlight r %}
degMA <- runLimma(df=mas5df, comp_list, fdr=0.10, foldchange=1, verbose=TRUE, affyid=NULL)
degMA <- degMA[ , !is.na(colSums(degMA))] # Remove columns where DEG analysis was not possible
write.table(degMA, file="./results/degMA.xls", quote=FALSE, sep="\t", col.names = NA) 
saveRDS(degMA, "./results/degMA.rds")
{% endhighlight %}


## Obtain annotation information
The following generates annotation information for the Affymetirx probe set
identifiers.  Note, the three different Affymetrix chip types used by CMAP
share most probe set ids (>95%), meaning it is possible to combine the data
after normalization and use the same annotation package for all of them. The
annotation libraries for the chip types HG-U133A and HT_HG-U133A are
`hgu133a.db` and `hthgu133a.db`, respectively. However, there is no annotation 
library (e.g. CDF) available for U133AAofAv2. 


{% highlight r %}
library(hgu133a.db)
myAnnot <- data.frame(ACCNUM=sapply(contents(hgu133aACCNUM), paste, collapse=", "), 
                             SYMBOL=sapply(contents(hgu133aSYMBOL), paste, collapse=", "), 
                             UNIGENE=sapply(contents(hgu133aUNIGENE), paste, collapse=", "), 
                             ENTREZID=sapply(contents(hgu133aENTREZID), paste, collapse=", "), 
                             ENSEMBL=sapply(contents(hgu133aENSEMBL), paste, collapse=", "), 
                             DESC=sapply(contents(hgu133aGENENAME), paste, collapse=", "))
saveRDS(myAnnot, "./results/myAnnot.rds")
{% endhighlight %}


## Transform probe set to gene level data

The `probeset2gene` function translates a binary DEG matrix from the probe level (`row.names` are
Affy IDs) to the gene level (`row.names` are gene IDs). Genes represented by several probe
sets (rows) will be collapsed based on a chosen summary rule. The following summary rules are
supported: `summary_rule=1L` will consider a gene as a DEG for a specific treatment if at 
least one of several probe sets supports this assignment, while `summary_rule=2L` requires 
support from at least 2 probe sets.


{% highlight r %}
myAnnot <- readRDS("./results/myAnnot.rds") 
degMA <- readRDS("./results/degMA.rds") # Faster than read.delim()
degMAgene <- probeset2gene(degMA, myAnnot, geneIDtype="ENTREZID", summary_rule=1L)
saveRDS(degMAgene, "./results/degMAgene.rds")
{% endhighlight %}

## Number of DEGs per drug treatment


{% highlight r %}
degMAgene <- readRDS("./results/degMAgene.rds")
y <- as.numeric(colSums(degMAgene))
interval <- table(cut(y, right=FALSE, dig.lab=5,  breaks=c(0, 5, 10, 50, 100, 200, 500, 1000, 10000)))
df <- data.frame(interval); colnames(df) <- c("Bins", "Counts")
ggplot(df, aes(Bins, Counts)) + 
       geom_bar(position="dodge", stat="identity", fill="cornflowerblue") + 
       ggtitle("DEG numbers by bins")
{% endhighlight %}


## Identify DEG overlaps with Peters et al. [-@Peters2015-fc]

Peters et al. [-@Peters2015-fc] reported 1,497 age-related gene expression
signatures.  The `intersectStats` function computes their intersects with each
of the 3,318 drug-responsive DEG sets from CMAP. The result includes the
Jaccard index as a simple similarity metric for gene sets as well as the raw
and adjusted p-values based on the hypergeometric distribution expressing how
likely it is to observe the observed intersect sizes just by chance. The
results for the 20 top scoring drugs are given below and the full data set is
written to a file named
[`degOL_PMID26490707.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/degOL_PMID26490707.xls).


{% highlight r %}
PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#")
myAnnot <- readRDS("./results/myAnnot.rds") 
geneid <- as.character(PMID26490707$"NEW.Entrez.ID")
degMAgene <- readRDS("./results/degMAgene.rds") # Faster than read.delim()
degMAsub <- degMAgene[rownames(degMAgene) %in% geneid,]
degOL_PMID26490707 <- intersectStats(degMAgene, degMAsub)
write.table(degOL_PMID26490707, file="./results/degOL_PMID26490707.xls", quote=FALSE, sep="\t", col.names = NA) 
sum(degOL_PMID26490707[,1] > 0) # Drugs with any overlap
degOL_PMID26490707[1:20,]
{% endhighlight %}


## Identify DEG overlaps with Sood et al. [-@Sood2015-pb]

Sood et al. [-@Sood2015-pb] reported 150 age-related gene expression signatures. 
The `intersectStats` function computes their intersects with each of the 3,318 
drug-responsive DEG sets from CMAP. The result includes the Jaccard index as a simple 
similarity metric for gene sets as well as the raw and adjusted p-values based on the 
hypergeometric distribution expressing how likely it is to observe the observed intersect 
sizes just by chance. The results for the 20 top scoring drugs are given below and the full
data set is written to a file named [`degOL_PMID26343147.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/degOL_PMID26343147.xls).


{% highlight r %}
PMID26343147 <- read.delim("./data/PMID26343147_S1T1.xls", check.names=FALSE, comment="#")
myAnnot <- readRDS("./results/myAnnot.rds") 
affyid <- row.names(myAnnot[myAnnot[,"SYMBOL"] %in% PMID26343147[,"Gene Symbol"], ]) 
degMA <- readRDS("./results/degMA.rds") # Faster then read.delim()
degMA <- degMA[ , !is.na(colSums(degMA))] # Remove columns where DEG analysis was not possible
degMAsub <- degMA[affyid,]
degOL_PMID26343147 <- intersectStats(degMAgene, degMAsub)
write.table(degOL_PMID26343147, file="./results/degOL_PMID26343147.xls", quote=FALSE, sep="\t", col.names = NA) 
sum(degOL_PMID26343147[,1] > 0) # Drugs with any overlap
degOL_PMID26343147[1:20,] # Top 20 scoring drugs
{% endhighlight %}

## Drugs affecting known longevity genes

The following identifies CMAP drugs affecting the expression of the IGF1 or IGF1R genes.
The final result is written to a file named [`deg_IGF1.xls`](http://biocluster.ucr.edu/~tgirke/projects/longevity/cmap/results/deg_IGF1.xls).


{% highlight r %}
genesymbols <- c("IGF1", "IGF1R")
geneids <- unique(as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"ENTREZID"]))
names(geneids) <- unique(as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"SYMBOL"]))
degMAgene <- readRDS("./results/degMAgene.rds") # Faster than read.delim()
df <- data.frame(row.names=colnames(degMAgene), check.names=FALSE)
for(i in seq_along(geneids)) df <- cbind(df, as.numeric(degMAgene[geneids[i],]))
colnames(df) <- names(geneids)
df <- df[rowSums(df)>0,]
nrow(df) # Number of drugs affecting at least one of: IGF1 or IGF1R
{% endhighlight %}

The following computes the `limma` FDR values for the corresponding genes (here IGF1 and IGF1R) 
and drug treatments.

{% highlight r %}
affyids2 <- row.names(myAnnot[myAnnot$SYMBOL %in% genesymbols,])
affyids <- as.character(myAnnot[myAnnot$SYMBOL %in% genesymbols,"SYMBOL"])
names(affyids) <- affyids2
cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE) 
comp_list <- sampleList(cmap, myby="CMP_CELL")
comp_list <- comp_list[row.names(df)]
degList <- runLimma(df=mas5df, comp_list, fdr=0.10, foldchange=1, verbose=FALSE, affyid=names(affyids))
pvalDF <- sapply(unique(affyids), function(x) sapply(rownames(df), function(y) min(degList[[y]][affyids==x,"adj.P.Val"])))
colnames(pvalDF) <- paste0(colnames(pvalDF), "_FDR")
df <- cbind(df, pvalDF)
write.table(df, file="./results/deg_IGF1.xls", quote=FALSE, sep="\t", col.names = NA) 
{% endhighlight %}

Now the final `data.frame` can be sorted by increasing mean FDR values. 

{% highlight r %}
igfDF <- read.delim("./results/deg_IGF1.xls", row.names=1)
igfDF[order(rowMeans(igfDF[,3:4])),][1:20,]
{% endhighlight %}


