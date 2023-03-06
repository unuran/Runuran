\name{udbinom}
\docType{function}

\alias{udbinom}

\title{UNU.RAN object for Binomial distribution}

\description{
  Create UNU.RAN object for the Binomial distribution
  with parameters \code{size} and \code{prob}.
  
  [Distribution] -- Object: Binomial.  %% Discrete
}

\usage{
udbinom(size, prob, lb = 0, ub = size)
}
\arguments{
  \item{size}{number of trials (one or more).}
  \item{prob}{probability of success on each trial.}
  \item{lb}{lower bound of (truncated) distribution.}
  \item{ub}{upper bound of (truncated) distribution.}
}

\details{
  The Binomial distribution with \code{size} \eqn{= n} and
  \code{prob} \eqn{= p} has density
  \deqn{p(x) = {n \choose x} {p}^{x} {(1-p)}^{n-x}}{
    p(x) = choose(n,x) p^x (1-p)^(n-x)}
  for \eqn{x = 0, \ldots, n}.
}

\value{
  An object of class \code{"unuran.discr"}.
}

\seealso{
  \code{\linkS4class{unuran.discr}}.
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

\examples{
## Create distribution object for binomial distribution
dist <- udbinom(size=100, prob=0.33)
## Generate generator object; use method DGT (inversion)
gen <- unuran.new(dist,"dgt")
## Draw a sample of size 1000
x <- ur(gen,1000)
}

\keyword{distribution}
\keyword{datagen}

