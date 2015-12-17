\name{geneGrep}
\alias{geneGrep}
\title{Gene ID query
}
\description{
The \code{geneGrep} function takes GTEx results and gene list as arguments, 
returns GTEx eSNP results for genes in gene lists. Genes without significant 
eSNPs are removed from results. 
}
\usage{
geneGrep(dat, genes)
}
\arguments{
  \item{dat}{
Object of class \code{data.frame}.
}
  \item{genes}{
Gene IDs stored in \code{character} vector.
}
}
\value{
Object of class \code{data.frame}.
}
\author{
Daniel Evans
}

\seealso{
\code{read.delim}
}
\examples{
library(longevityTools)
## Download of eQTL data from GTEx: http://www.gtexportal.org/home/datasets
## Note, this downloads a 1.3GB file, which will take some time.

\dontrun{
download.file("http://www.gtexportal.org/static/datasets/gtex_analysis_v6/single_tissue_eqtl_data/GTEx_Analysis_V6_eQTLs.tar.gz", "./GTEx_Analysis_V6_eQTLs.tar.gz")
untar("GTEx_Analysis_V6_eQTLs.tar.gz")
}
## The following sample file 'Whole_Blood_Analysis.snpgenes' was subsetted to first 100 rows
samplepath <- system.file("extdata", "Whole_Blood_Analysis.snpgenes.head100", package="longevityTools") 
dat <- read.delim(samplepath)
myGenes <- c("RP11-693J15.4", "RP11-809N8.4", "junkNoMatch")
result <- geneGrep(dat, myGenes)
}
\keyword{ utilities }
