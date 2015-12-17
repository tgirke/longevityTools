samplepath <- system.file("extdata", "Whole_Blood_Analysis.snpgenes.head100", package="longevityTools")
test.import <- function(){
	## Test import of eQTL file
	dat <- read.delim(samplepath)
    checkTrue(nrow(dat)==100)
}
