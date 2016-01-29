#########################################################
## Functions for Connectivity Map (CMAP) Data Analysis ##
#########################################################
## Author: Thomas Girke
## Last update: 08-Jan-16

## Download rank matrix and compound annotation files from CMAP (http://www.broadinstitute.org/cmap
getCmap <- function(rerun=TRUE) {
    ## Check for presence of target directory
    if(dir.exists("./data")!=TRUE) stop("Target directory ./data does not exist. Create it to run function.") 
    if(rerun==TRUE) {
        ## Rank matrix
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/rankMatrix.txt.zip", "./data/rankMatrix.txt.zip")
        unzip("./data/rankMatrix.txt.zip", exdir="./data"); unlink("./data/rankMatrix.txt.zip")
        ## CMAP instances (compound annotations)
        download.file("http://www.broadinstitute.org/cmap/cmap_instances_02.xls", "./data/cmap_instances_02.xls")
    } else {
        print("To execute function, set 'rerun=TRUE'")
    }
}
## Usage:
# getCmap(rerun=TRUE)

## Download CEL files from CMAP (http://www.broadinstitute.org/cmap
getCmapCEL <- function(rerun=TRUE) {
    ## Check for presence of target directory
    if(dir.exists("./data/CEL")!=TRUE) stop("Target directory ./data/CEL does not exist. Create it to run function.") 
    if(rerun==TRUE) {
        ## Download CEL files
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume1of7.zip", "./data/CEL/cmap_build02.volume1of7.zip")
        unzip("./data/CEL/cmap_build02.volume1of7.zip", exdir="./data/CEL"); unlink("./data/CEL/cmap_build02.volume1of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume2of7.zip", "./data/CEL/cmap_build02.volume2of7.zip")
        unzip("./data/CEL/cmap_build02.volume2of7.zip", exdir="./data/CEL"); unlink("./data/CEL/cmap_build02.volume2of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume3of7.zip", "./data/CEL/cmap_build02.volume3of7.zip")
        unzip("./data/CEL/cmap_build02.volume3of7.zip", exdir="./data/CEL"); unlink("./data/CEL/cmap_build02.volume3of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume4of7.zip", "./data/CEL/cmap_build02.volume4of7.zip")
        unzip("./data/CEL/cmap_build02.volume4of7.zip", exdir="./data/CEL"); unlink("./data/CEL/cmap_build02.volume4of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume5of7.zip", "./data/CEL/cmap_build02.volume5of7.zip")
        unzip("./data/CEL/cmap_build02.volume5of7.zip", exdir="./data/CEL"); unlink("./data/CEL/cmap_build02.volume5of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume6of7.zip", "./data/CEL/cmap_build02.volume6of7.zip")
        unzip("./data/CEL/cmap_build02.volume6of7.zip", exdir="./data/CEL"); unlink("./data/CEL/cmap_build02.volume6of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build03.volume7of7.zip", "./data/CEL/cmap_build02.volume7of7.zip")
        unzip("./data/CEL/cmap_build02.volume7of7.zip", exdir="./data/CEL"); unlink("./data/CEL/cmap_build02.volume7of7.zip")
        
        ## Uncompress CEL files
        myfiles <- list.files("./data/CEL", pattern=".CEL.bz2$", full.names=TRUE)
        for(i in myfiles) R.utils::bunzip2(i, remove=TRUE)
    } else {
        print("To execute function, set 'rerun=TRUE'")
    }
}
## Usage:
# getCmapCEL(rerun=TRUE)

## Process each chip type separately running MAS5 with BiocParallel on cluster
normalizeCel <- function(chiptype_list, rerun=TRUE) {
    if(rerun==TRUE) {
        for(i in names(chiptype_list)) {
            saveRDS(chiptype_list[[i]], "./data/chiptype_tmp.rds")
            celfiles <- readRDS("./data/chiptype_tmp.rds")
            batchsize <- 100
            cel_list <- suppressWarnings(split(celfiles, rep(1:(ceiling(length(celfiles)/batchsize)), each=batchsize)))
            dir.create(paste0("./data/", i))
            batchjobs_file <- system.file("extdata", ".BatchJobs.R", package="longevityTools")
            torque_file <- system.file("extdata", "torque.tmpl", package="longevityTools")
            file.copy(c(torque_file, batchjobs_file), paste0("./data/", i))
            mydir <- getwd()
            setwd(paste0("./data/", i))
            ## Function to run MAS5 on cluster with BiocParallel
            f <- function(x) {
                celfiles <- readRDS("../chiptype_tmp.rds")
                batchsize <- 100
                cel_list <- suppressWarnings(split(celfiles, rep(1:(ceiling(length(celfiles)/batchsize)), each=batchsize)))
                dir.create(paste0("cellbatch_", x))
                mydata <- ReadAffy(filenames=cel_list[[x]], celfile.path="../CEL")
                eset <- mas5(mydata)
                eset_pma <- mas5calls(mydata) # Generates MAS 5.0 P/M/A calls.
                write.table(exprs(eset), file=paste0("cellbatch_", x, "/mas5exprs.xls"), , quote=FALSE, sep="\t", col.names = NA) 
                write.table(exprs(eset_pma), file=paste0("cellbatch_", x, "/mas5pma.xls"), quote=FALSE, sep="\t", col.names = NA) 
                write.table(assayDataElement(eset_pma, "se.exprs"), file=paste0("cellbatch_", x, "/mas5pval.xls"), quote=FALSE, sep="\t", col.names = NA) 
            }
            funs <- makeClusterFunctionsTorque("torque.tmpl")
            param <- BatchJobsParam(length(cel_list), resources=list(walltime="20:00:00", nodes="1:ppn=1", memory="12gb"), cluster.functions=funs)
            register(param)
            resultlist <- bplapply(names(cel_list), f)
            setwd(mydir)
            unlink("./data/chiptype_tmp.rds")
        }
    } else {
        print("To execute function, set 'rerun=TRUE'")
    }
}
## Usage:
# chiptype_list <- split(names(chiptype), as.character(chiptype))
# normalizeCel(chiptype_list, rerun=TRUE)

## Combine results from same chip type in single data frame
combineResults <- function(chiptype_dir, rerun=TRUE) {
    if(rerun==TRUE) {
    for(j in seq_along(chiptype_dir)) {
        mydirs <- list.files(paste0("data/", chiptype_dir[j]), pattern="cellbatch_", full.names=TRUE)
        for(i in seq_along(mydirs)) {
            if(i==1) {
                df1 <- read.delim(paste0(mydirs[i], "/", "mas5exprs.xls"), row.names=1, check.names=FALSE)
                df2 <- read.delim(paste0(mydirs[i], "/", "mas5pma.xls"), row.names=1, check.names=FALSE)
                df3 <- read.delim(paste0(mydirs[i], "/", "mas5pval.xls"), row.names=1, check.names=FALSE)
            } else {
                tmpdf1 <- read.delim(paste0(mydirs[i], "/", "mas5exprs.xls"), row.names=1, check.names=FALSE)
                df1 <-cbind(df1, tmpdf1)
                tmpdf2 <- read.delim(paste0(mydirs[i], "/", "mas5pma.xls"), row.names=1, check.names=FALSE)
                df2 <-cbind(df2, tmpdf2)
                tmpdf3 <- read.delim(paste0(mydirs[i], "/", "mas5pval.xls"), row.names=1, check.names=FALSE)
                df3 <-cbind(df3, tmpdf3)
            }
            cat("Processed", i, "of", length(mydirs), "\n")
        }
        write.table(df1, paste0("data/", chiptype_dir[j], "/all_mas5exprs.xls"), quote=FALSE, sep="\t", col.names = NA) 
        saveRDS(df1, paste0("data/", chiptype_dir[j], "/", "all_mas5exprs.rds")) # For fast loading
        cat("Generated", paste0("data/", chiptype_dir[j], "/all_mas5exprs.xls"), "\n")
        write.table(df2, paste0("data/", chiptype_dir[j], "/all_mas5pma.xls"), quote=FALSE, sep="\t", col.names = NA) 
        cat("Generated", paste0("data/", chiptype_dir[j], "/all_mas5pma.xls"), "\n")
        write.table(df3, paste0("data/", chiptype_dir[j], "/all_mas5pval.xls"), quote=FALSE, sep="\t", col.names = NA) 
        cat("Generated", paste0("data/", chiptype_dir[j], "/all_mas5pval.xls"), "\n")
    }
    } else {
        print("To execute function, set 'rerun=TRUE'")
    }
}
## Usage:
# chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
# combineResults(chiptype_dir, rerun=TRUE)

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
