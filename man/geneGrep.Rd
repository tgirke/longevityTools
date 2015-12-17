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
}
\examples{
library(longevityTools)
samplepath <- system.file("extdata", "Whole_Blood_Analysis.snpgenes.head100", package="longevityTools") 
read.delim(samplepath)

\dontrun{
dat <- read.table("~/Documents/longevity/GTEx/data/Whole_Blood_Analysis.snpgenes.head100", header=TRUE, sep="\t", stringsAsFactors=FALSE)
myGenes<- c("RP11-693J15.4", "RP11-809N8.4", "junkNoMatch")
result <- geneGrep(dat, myGenes)
}
}
\keyword{ utilities }
