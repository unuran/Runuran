\name{udnorm}
\docType{function}

\alias{udnorm}

\title{UNU.RAN object for Normal distribution}

\description{
  Create UNU.RAN object for Normal (Gaussian) distribution with mean
  equal to \code{mean} and standard deviation to \code{sd}.
  
  [Distribution] -- Object: Normal (Gaussian).  %% Continuous
}

\usage{
udnorm(mean = 0, sd = 1, lb = -Inf, ub = Inf)
}
\arguments{
  \item{mean}{mean of distribution.}
  \item{sd}{standard deviation.}
  \item{lb}{lower bound of (truncated) distribution.}
  \item{ub}{upper bound of (truncated) distribution.}
}

\details{
  If \code{mean} or \code{sd} are not specified they assume the default
  values of \code{0} and \code{1}, respectively.

  The normal distribution has density
  \deqn{
    f(x) =
    \frac{1}{\sqrt{2\pi}\sigma} e^{-(x-\mu)^2/2\sigma^2}}{
    f(x) = 1/(sqrt(2 pi) sigma) e^-((x - mu)^2/(2 sigma^2))
  }
  where \eqn{\mu}{mu} is the mean of the distribution and
  \eqn{\sigma}{sigma} the standard deviation.
}

\value{
  An object of class \code{"unuran.cont"}.
}

\seealso{
  \code{\linkS4class{unuran.cont}}.
}

\references{
  W. H\"ormann, J. Leydold, and G. Derflinger (2004):
  Automatic Nonuniform Random Variate Generation.
  Springer-Verlag, Berlin Heidelberg
}

\author{
  Josef Leydold and Wolfgang H\"ormann
  \email{unuran@statmath.wu-wien.ac.at}.
}

\note{
  This function is a wrapper for the UNU.RAN class in \R.
  Compared to \code{rnorm}, \code{urnorm} is faster, especially for
  larger sample sizes.
  However, in opposition to \code{rnorm} vector arguments are ignored,
  i.e. only the first entry is used.
}

\examples{
## Create distribution object for standard normal distribution
dist <- udnorm()
## Generate generator object; use method PINV (inversion)
gen <- unuran.new(dist,"pinv")
## Draw a sample of size 1000
x <- ur(gen,1000)

## Create distribution object for positive normal distribution
dist <- udnorm(lb=0, ub=Inf)
## ... and draw a sample
gen <- unuran.new(dist,"pinv")
x <- ur(gen,1000)
}

\keyword{distribution}
\keyword{datagen}

