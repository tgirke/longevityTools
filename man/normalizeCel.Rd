\name{normalizeCel}
\alias{normalizeCel}
\alias{combineResults}
\title{
Batch normalization of Affymetrix chips on cluster
}
\description{
Function to processe large numbers of CEL files from different chip types 
separately using the MAS5 normalization algorithm. To improve time performance, 
the processing is parallelized with \code{BiocParallel} to run on a computer cluster with a 
scheduler (e.g. Torque).
}
\usage{
normalizeCel(chiptype_list, rerun = TRUE)

combineResults(chiptype_dir, rerun = TRUE)
}
\arguments{
  \item{chiptype_list}{
    \code{list} of character vectors specifying CEL file names from same chip type. The list components are named after the chip types.
}
  \item{chiptype_dir}{
Paths to CEL file directory specified in \code{character} vector.
}
  \item{rerun}{
If \code{rerun} set to \code{TRUE}, the function will be executed, while 
\code{FALSE} returns a usage message.
}
}
\details{
The \code{normalizeCel} function will write the results to sub-directories within the 
\code{data} directory. The sub-directories will be named after the chip types. Each one 
of them will contain three files containing the MAS5 normalized intensities, the 
corresponding P/M/A calls and the Wilcoxon rank p-values.

The function \code{combineResults} will write the combined results to the same directories
as \code{normalizeCel}.

Note: more detailed information should be added to this help file.
}
\value{
Files written to disk. 
}
\author{
Thomas Girke
}

\examples{

\dontrun{
## Normalization of CEL files
library(BiocParallel); library(BatchJobs); library(affy) 
chiptype_list <- split(names(chiptype), as.character(chiptype))
normalizeCel(chiptype_list, rerun=FALSE)

## Combine results from same chip type in single data.frame
chiptype_dir <- unique(readRDS("./data/chiptype.rds"))
combineResults(chiptype_dir, rerun=FALSE)

}
}
\keyword{ utilities }
