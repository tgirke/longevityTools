\name{getCmap}
\alias{getCmap}
\alias{getCmapCEL}
\title{
Download CMAP data
}
\description{
The \code{getCmap} function downloads the CMAP rank matrix along with the compound 
annotations, and \code{getCmapCEL} downloads the corresponding 7,056 CEL files.
}
\usage{
getCmap(rerun = TRUE)

getCmapCEL(rerun = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rerun}{
If \code{rerun} set to \code{TRUE}, the function will perform the download, while 
\code{FALSE} returns a usage message.
}
}
\details{
The functions will write the downloaded files to a \code{data} directory within the
present workding directory of the user's R session. This \code{data} directory plus
a \code{data/CEL} sub-directory need to be created by the user prior to running the
download functions. 
}
\value{
Files written to disk. 
}
\author{
Thomas Girke
}
\examples{

\dontrun{
## Downloads cmap rank matrix and compound annotation files
getCmap(rerun=TRUE)


## Downloads cmap CEL files (take some time!)
getCmapCEL(rerun=TRUE)

}
}
\keyword{ utilities }
