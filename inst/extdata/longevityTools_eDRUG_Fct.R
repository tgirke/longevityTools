###############################################################################
## Functions that are in early development for drug vs. age analysis project ##
###############################################################################
## Author: Thomas Girke
## Last update: 08-Jan-16

## Function to compute intersect stats among query gene set and DEG set (e.g. from CMAP)
## It includes Jaccard index and p-value of intersect based on hypergeometric distribution
intersectStats <- function(degMAgene, degMAsub) {
    ## Jaccard index
    c <- colSums(degMAsub==1) # Common in both (c)
    a <- colSums(degMAsub==0) # Only in query (a)
    b <- colSums(degMAgene==1) - c # Only in cmap (b)
    j <- c/(c+a+b) # Jaccard similarity 

    ## Assemble results in data.frame
    df <- data.frame(Compound_Celltype=names(j), 
                     Jaccard_Index=as.numeric(j), 
                     longevity_DEG=as.numeric(a) + as.numeric(c),
                     cmap_DEG=as.numeric(b) + as.numeric(c), 
                     Intersect=as.numeric(c))

    ## Calculate p-value for intersect based on hypergeometric distribution
    intersect=as.numeric(df$Intersect)
    s1=as.numeric(df$longevity_DEG)
    s2=as.numeric(df$cmap_DEG)
    universe=nrow(degMAgene)
    pval <- phyper(q=intersect-1, m=s1, n=universe-s1, k=s2, lower.tail = FALSE, log.p = FALSE)
    
    ## Bonferroni p-value adjustment
    adj_pval <- pval * length(intersect)
    adj_pval[adj_pval>1] <- 1

    ## Assemble results in data.frame
    df <- data.frame(df, Pval=pval, adj_Pval=adj_pval)
    df <- df[order(df$adj_Pval),] # Sort by adj_Pvalue
    row.names(df) <- NULL
    return(df)
}
## Usage:
# PMID26490707 <- read.delim("./data/PMID26490707_S1.xls", comment="#")
# myAnnot <- readRDS("./results/myAnnot.rds") 
# geneid <- as.character(PMID26490707$"NEW.Entrez.ID")
# degMAgene <- readRDS("./results/degMAgene.rds") # Faster than read.delim()
# degMAsub <- degMAgene[rownames(degMAgene) %in% geneid,]
# degOL_PMID26490707 <- intersectStats(degMAgene, degMAsub)

