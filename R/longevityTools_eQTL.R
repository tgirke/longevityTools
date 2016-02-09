## parse GTEx results
## GTEx_Analysis_V6_eQTLs.tar.gz
## head -n100 Whole_Blood_Analysis.snpgenes > Whole_Blood_Analysis.snpgenes.head100
## ...

geneGrep <- function(dat,genes){
  if(sum(dat$gene_name %in% genes)>0){
    myRows <- which(dat$gene_name %in% genes)
    dat2 <- dat[myRows, c("snp","beta", "p_value", "ref", "alt", "gene_name")]
    return(dat2)
  } else {
    print("No matches")
  }
}

## Usage:
# dat <- read.table("~/Documents/longevity/GTEx/data/Whole_Blood_Analysis.snpgenes.head100", header=TRUE, sep="\t", stringsAsFactors=FALSE)
# myGenes<- c("RP11-693J15.4", "RP11-809N8.4", "junkNoMatch")
# result <- geneGrep(dat, myGenes)

