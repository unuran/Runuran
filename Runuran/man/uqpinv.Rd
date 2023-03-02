\name{uqpinv}
\docType{function}

\alias{uqpinv}

\title{Quantile function using UNU.RAN method PINV}

\description{
  Evaluates quantile of distribution approximately using
  UNU.RAN method PINV.
}

\usage{
uqpinv(unur, U)
}
\arguments{
  \item{unur}{a "unuran" object using method \dQuote{PINV}.}
  \item{U}{vector of probabilities.}
}

\details{
  This routine evaluates the quantiles (inverser CDF) for a given
  (vector of) probabilities approximately.
  It requires a "unuran" object that uses method \dQuote{PINV} and thus
  contains the information about the target distribution.
}

\seealso{
  \code{\linkS4class{unuran}}.
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
## Compute quantiles of normal distribution
unr <- unuran.new("normal()","pinv")
uqpinv(unr,0.975)
uqpinv(unr,c(0.025,0.975))

## Compute quantiles of user-defined distribution
## PDF need not integrate to one
pdf <- function (x) { exp(-(x*x)/2) }
dist <- new("unuran.cont", pdf=pdf, islog=FALSE)
unr <- unuran.new(dist, "pinv; u_resolution=1.e-12")
uqpinv(unr,seq(0,1,0.05))

}

\keyword{distribution}
\keyword{datagen}

