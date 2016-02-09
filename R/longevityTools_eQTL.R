## parse GTEx results
## GTEx_Analysis_V6_eQTLs.tar.gz
## head -n100 Whole_Blood_Analysis.snpgenes > Whole_Blood_Analysis.snpgenes.head100
## ...

geneGrep <- function(dat,genes){
  if(sum(dat$gene_name %in% genes)>0){
    myRows <- which(dat$gene_name %in% genes)
    dat2 <- dat[myRows, c("snp","beta", "p_value", "ref", "alt", "gene_name","nom_thresh","snp_chrom","snp_pos","snp_id_1kg_project_phaseI_v3","rs_id_dbSNP142_GRCh37p13")]
    return(dat2)
  } else {
    print("No matches")
  }
}

## Usage:
# dat <- read.table("~/Documents/longevity/GTEx/data/Whole_Blood_Analysis.snpgenes.head100", header=TRUE, sep="\t", stringsAsFactors=FALSE)
# myGenes<- c("RP11-693J15.4", "RP11-809N8.4", "junkNoMatch")
# result <- geneGrep(dat, myGenes)

filter_1KGsamples <- function(pop,ped_file,pop_file){
  if(pop %in% c("AFR","AMR","EAS","EUR","SAS")){
    pop_file <- pop_file[pop_file$super_pop==pop,]
    ped_file <- ped_file[ped_file$related.genotypes==0,]
    result<-merge(ped_file,pop_file,by.x="Individual.ID",by.y="sample")
    return(result)
  } else {
    print(paste(pop, "not found in pop_file."))
  }
}


