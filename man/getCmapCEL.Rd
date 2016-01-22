\name{getCmapCEL}
\alias{getCmapCEL}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getCmapCEL(rerun = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rerun}{
%%     ~~Describe \code{rerun} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (rerun = TRUE) 
{
    if (dir.exists("./data/CEL") != TRUE) 
        stop("Target directory ./data/CEL does not exist. Create it to run function.")
    if (rerun == TRUE) {
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume1of7.zip", 
            "./data/CEL/cmap_build02.volume1of7.zip")
        unzip("./data/CEL/cmap_build02.volume1of7.zip", exdir = "./data/CEL")
        unlink("./data/CEL/cmap_build02.volume1of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume2of7.zip", 
            "./data/CEL/cmap_build02.volume2of7.zip")
        unzip("./data/CEL/cmap_build02.volume2of7.zip", exdir = "./data/CEL")
        unlink("./data/CEL/cmap_build02.volume2of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume3of7.zip", 
            "./data/CEL/cmap_build02.volume3of7.zip")
        unzip("./data/CEL/cmap_build02.volume3of7.zip", exdir = "./data/CEL")
        unlink("./data/CEL/cmap_build02.volume3of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume4of7.zip", 
            "./data/CEL/cmap_build02.volume4of7.zip")
        unzip("./data/CEL/cmap_build02.volume4of7.zip", exdir = "./data/CEL")
        unlink("./data/CEL/cmap_build02.volume4of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume5of7.zip", 
            "./data/CEL/cmap_build02.volume5of7.zip")
        unzip("./data/CEL/cmap_build02.volume5of7.zip", exdir = "./data/CEL")
        unlink("./data/CEL/cmap_build02.volume5of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build02.volume6of7.zip", 
            "./data/CEL/cmap_build02.volume6of7.zip")
        unzip("./data/CEL/cmap_build02.volume6of7.zip", exdir = "./data/CEL")
        unlink("./data/CEL/cmap_build02.volume6of7.zip")
        download.file("ftp://ftp.broad.mit.edu/pub/cmap/cmap_build03.volume7of7.zip", 
            "./data/CEL/cmap_build02.volume7of7.zip")
        unzip("./data/CEL/cmap_build02.volume7of7.zip", exdir = "./data/CEL")
        unlink("./data/CEL/cmap_build02.volume7of7.zip")
        library(R.utils)
        myfiles <- list.files("./data/CEL", pattern = ".CEL.bz2$", 
            full.names = TRUE)
        for (i in myfiles) R.utils::bunzip2(i, remove = TRUE)
    }
    else {
        print("To execute function, set 'rerun=TRUE'")
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
