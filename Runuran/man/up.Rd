\name{up}
\docType{function}

\alias{up}

\title{Distribution function for "unuran" object}

\description{
  Evaluates the cumulative distribution function (CDF) 
  of a "unuran" object for a continuous or discrete distribution.
}

\usage{
up(obj, x)
}
\arguments{
  \item{obj}{distribution object
    (S4 object of class \code{"unuran.cont"} or \code{"unuran.discr"}),
    or generator object (S4 object of class \code{"unuran"}).
  }
  \item{x}{vector of x values. (numeric)}
}

\details{
  The routine evaluates the cumulative distribution function of a
  distribution stored in a UNU.RAN distribution object or UNU.RAN
  generator object. 
  (If the CDF is not available in the object, then the
  computation is aborted.) 
}

\seealso{
  \code{\linkS4class{unuran.cont}},
  \code{\linkS4class{unuran.discr}},
  \code{\linkS4class{unuran}}.
}

\references{
  W. H\"ormann, J. Leydold, and G. Derflinger (2004):
  Automatic Nonuniform Random Variate Generation.
  Springer-Verlag, Berlin Heidelberg.
}

\author{
  Josef Leydold and Wolfgang H\"ormann
  \email{unuran@statmath.wu.ac.at}.
}

\examples{
## Create an UNU.RAN distribution object (for standard Gaussian)
## and evaluate density for some points
distr <- udnorm()
up(distr, 1.5)
up(distr, -3:3)

## Create an UNU.RAN generator object (for standard Gaussian)
## and evaluate density of underyling distribution
gen <- tdrd.new(udnorm())
up(gen, 1.5)
up(gen, -3:3)

}
