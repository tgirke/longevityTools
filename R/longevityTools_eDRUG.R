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
