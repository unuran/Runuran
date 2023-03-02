\name{unuran.cmv}
\docType{function}

\alias{unuran.cmv}

\title{Create a UNU.RAN continuous multivariate distribution object}

\description{
  Create a new UNU.RAN object for a continuous multivariate distribution.
  The interface might be changed in future releases.
  \strong{Do not use unnamed arguments!}
}

\usage{
unuran.cmv(dim=1, pdf=NULL, mode=NULL, center=NULL, ll=NULL, ur=NULL)
}
\arguments{
  \item{dim}{number of dimensions of the distribution. (integer)}
  \item{pdf}{probability density function. (\R function)}
  \item{mode}{location of the mode. (numeric vector -- optional)}
  \item{center}{point in \dQuote{typical} region of distribution,
    e.g. the approximate location of the mode. It is used by several
    methods to locate the main region of the distribution.
    If omitted the \code{mode} is implicitly used. If the \code{mode}
    is not given either, the origin is used. (numeric vector --
    optional)}
  \item{ll,ur}{lower left and upper right vertex of a rectangular
    domain of the \code{pdf}. The domain is only set if both vertices
    are not \code{NULL}. Otherwise, the domain is unbounded by default.
    (numeric vectors)}
}

\details{
  Creates an instance of class \code{\linkS4class{unuran.cmv}}.
  For more details see also \code{\link{unuran.new}}.

  The user is responsible that the given informations are consistent.
  It depends on the chosen method which information must be given / are
  used.
}

\note{
  \code{unuran.cmv(\ldots)} is an alias for 
  \code{new("unuran.cmv", \ldots)}.
}

\seealso{
  \code{\linkS4class{unuran.cont}}, \code{\link{unuran.new}}.
}

\references{
  W. H\"ormann, J. Leydold, and G. Derflinger (2004):
  Automatic Nonuniform Random Variate Generation.
  Springer-Verlag, Berlin Heidelberg.
}

\author{
  Josef Leydold and Wolfgang H\"ormann
  \email{unuran@statmath.wu-wien.ac.at}.
}

\examples{
## Get a distribution object with given pdf and mode
mvpdf <- function (x) { exp(-sum(x^2)) }
mvd <- unuran.cmv(dim=2, pdf=mvpdf, mode=c(0,0))

}

\keyword{distribution}
\keyword{datagen}

