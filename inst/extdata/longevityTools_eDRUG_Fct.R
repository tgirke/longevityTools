###############################################################################
## Functions that are in early development for drug vs. age analysis project ##
###############################################################################
## Author: Thomas Girke
## Last update: 08-Jan-16

## Generate CEL file list for treatment vs. control comparisons
sampleList <- function(cmap, myby) {
    ## Reconstruct CEL file names for control samples
    byCel_list <- split(cmap[, c("perturbation_scan_id", "vehicle_scan_id4")], as.character(cmap$perturbation_scan_id))
    sampleList1 <- function(x) {
        c <- unlist(strsplit(as.character(x[,2]), "\\."))
        if(max(nchar(c)>4)) {    
            c <- gsub("'", "", as.character(x[,2]))
        } else {
            c <- c[nchar(c)!=0]
            c <- paste0(gsub("\\..*", "", as.character(x[,1])), ".", c)
            c <- gsub("'", "", c) # Quite a few CEL file names have a "'" prepended 
        }
        t <- gsub("'", "", as.character(x[,1]))
        return(list(list(t=t, c=c)))
    }
    byCel_list <- sapply(byCel_list, sampleList1)
    
    ## Split by CMP only, or CMP and cell type
    if(myby=="CMP") {
        byCMP_list <- split(cmap[, c("cmap_name", "perturbation_scan_id")], as.character(cmap$cmap_name))
    }
    if(myby=="CMP_CELL") {
        cmap <- data.frame(cmp_cell=paste(cmap$cmap_name, cmap$cell2, sep="_"), cmap)
        byCMP_list <- split(cmap[, c("cmap_name", "perturbation_scan_id")], as.character(cmap$cmp_cell))
    }
    sampleList2 <- function(x, y=byCel_list) {
        s <- y[x[,2]]    
        l <- list(t=paste0(unique(as.character(unlist(sapply(seq_along(s), function(x) s[[x]]$t)))), ".CEL"),
                  c=paste0(unique(as.character(unlist(sapply(seq_along(s), function(x) s[[x]]$c)))), ".CEL"))
        return(list(l))
    }
    byCel_list <- sapply(names(byCMP_list), function(i) sampleList2(x=byCMP_list[[i]], y=byCel_list))
    return(byCel_list)
}
## Usage: 
# cmap <- read.delim("./data/cmap_instances_02.txt", check.names=FALSE) # Note: cmap_instances_02.xls converted to txt with LibreOffice
# comp_list <- sampleList(cmap, myby="CMP")
# comp_list <- sampleList(cmap, myby="CMP_CELL")

## DEG analysis with Limma
runLimma <- function(df, comp_list, fdr=0.05, foldchange=1, verbose=TRUE) {
    library(affy); library(limma)
    ## Generate result container
    deg <- matrix(0, nrow=nrow(df), ncol=length(comp_list), dimnames = list(rownames(df, names(comp_list))))
    colnames(deg) <- names(comp_list)
    ## Run limma
    for(i in seq_along(comp_list)) {
        sample_set <- unlist(comp_list[[i]])
        repcounts <- sapply(comp_list[[i]], length)
        repcounts <- paste("rep count:", paste(paste0(names(repcounts), repcounts), collapse="_"))
        ## The following if statement will skip sample sets with less than 3 CEL files (control and 
        ## treatment) or those containing non-existing CEL files. For tracking NAs will be injected 
        ## in the corresponding columns of the result matrix.
        if((length(sample_set)<3) | any(!sample_set %in% colnames(df))) {
            deg[, i] <- NA
            if(verbose==TRUE) {
                cat("Sample", i, "of", paste0(length(comp_list), ":"), paste0("not enough usable replicates (", repcounts, ")."), "\n")
            }
        } else {
            dfsub <- df[, sample_set]
            eset <- new("ExpressionSet", exprs = as.matrix(dfsub), annotation="hgu133a")
            repno <- rep(1:length(comp_list[[i]]), sapply(comp_list[[i]], length))
            design <- model.matrix(~ -1+factor(repno))
            colnames(design) <- names(comp_list[[i]])
            fit <- lmFit(eset, design) # Fit a linear model for each gene based on the given series of arrays
            contrast.matrix <- makeContrasts(contrasts="t-c", levels=design)
            fit2 <- contrasts.fit(fit, contrast.matrix)
            fit2 <- eBayes(fit2) # Computes moderated t-statistics and log-odds of differential expression by empirical Bayes shrinkage of the standard errors towards a common value.
            limmaDF <- topTable(fit2, coef=1, adjust="fdr", sort.by="B", number=Inf)
            pval <- limmaDF$adj.P.Val <= fdr # FDR 1%
            fold <- (limmaDF$logFC >= foldchange | limmaDF$logFC <= -foldchange) # Fold change 2
            affyids <- rownames(limmaDF[pval & fold,])
            deg[affyids, i] <- 1
            if(verbose==TRUE) {
                cat("Sample", i, "of", paste0(length(comp_list), ":"), "identified", length(affyids), paste0("DEGs (", repcounts, ")."), "\n")
            }
        }
    }
    return(deg)
}
## Usage:
# degMA <- runLimma(df, comp_list, fdr=0.10, foldchange=1, verbose=TRUE)
# write.table(degMA, file="./results/degMA.xls", quote=FALSE, sep="\t", col.names = NA) 


