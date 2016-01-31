\name{probeset2gene}
\alias{probeset2gene}
\title{
Transform probe set to gene level data
}
\description{
Function translates a binary DEG matrix from the probe level (\code{row.names} are
Affy IDs) to the gene level (\code{row.names} are gene IDs). Genes represented by several 
probe sets (rows) will be collapsed based on a chosen summary rule. 
}
\usage{
probeset2gene(degMA, myAnnot, geneIDtype = "ENTREZID", summary_rule = 1L)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{degMA}{
Binary DEG matrix where \code{row.names} are Affy IDs.
}
  \item{myAnnot}{
Annotation \code{data.frame} containing Affy to gene ID mappings.
}
  \item{geneIDtype}{
Single \code{character} value referencing the gene ID column in \code{myAnnot} that should
be used.
}
  \item{summary_rule}{
The following summary rules are supported: \code{summary_rule=1L} will consider a gene as a 
DEG for a specific treatment if at least one of several probe sets supports this assignment, 
while \code{summary_rule=2L} requires support from at least 2 probe sets.
}
}
\value{
Binary matrix where \code{row.names} are gene IDs and \code{col.names} treatments; 
1s indicate DEGs.
}
\author{
Thomas Girke
}
\examples{
\dontrun{
## Import input data
myAnnot <- readRDS("./results/myAnnot.rds")
degMA <- readRDS("./results/degMA.rds") # Faster than read.delim()

## Transform probe set to gene level data
degMAgene <- probeset2gene(degMA, myAnnot, geneIDtype="ENTREZID", summary_rule=1L)
saveRDS(degMAgene, "./results/degMAgene.rds")

}
}
\keyword{ utilities }
