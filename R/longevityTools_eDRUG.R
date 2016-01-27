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
        unzip("./data/rankMatrix.txt.zip"); unlink("./data/rankMatrix.txt.zip")
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
            file.copy(c("torque.tmpl", ".BatchJobs.R"), paste0("./data/", i))
            mydir <- getwd()
            setwd(paste0("./data/", i))
            ## Function to run MAS5 on cluster with BiocParallel
            f <- function(x) {
                library(affy)
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
