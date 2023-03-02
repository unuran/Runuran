\name{unuran.discr}
\docType{function}

\alias{unuran.discr}

\title{Create a UNU.RAN discrete univariate distribution object}

\description{
  Create a new UNU.RAN object for a discrete univariate distribution.
  The interface might be changed in future releases.
  \strong{Do not use unnamed arguments!}
}

\usage{
unuran.discr(pv=NULL, pmf=NULL, mode=NA, lb=0, ub=Inf, sum=NA)
}
\arguments{
    \item{pv}{probability vector. (numeric vector)}
    \item{pmf}{probability mass function. (\R function)}
    \item{mode}{mode of distribution. (numeric, integer)}
    \item{lb, ub}{lower and upper bound of domain. (numeric, integers)}
    \item{sum}{sum over \code{pv} / \code{pmf}; used for computing
      normalization constants if required. (numeric)}
}

\details{
  Creates an instance of class \code{\linkS4class{unuran.discr}}.
  For more details see also \code{\link{unuran.new}}.

  The user is responsible that the given informations are consistent.
  It depends on the chosen method which information must be given / are
  used.
}

\note{
  \code{unuran.discr(\ldots)} is an alias for 
  \code{new("unuran.discr", \ldots)}.
}

\seealso{
  \code{\linkS4class{unuran.discr}}, \code{\link{unuran.new}}.
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
## Get a distribution object with given PV and mode
mypv <- dbinom(0:100,100,0.3)
distr <- unuran.discr(pv=mypv, mode=30)

}

\keyword{distribution}
\keyword{datagen}

