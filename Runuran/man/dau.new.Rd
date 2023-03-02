\name{dau.new}
\docType{function}

\alias{dau.new}

\title{UNU.RAN generator based on the Alias method (DAU)}

\description{
  UNU.RAN random variate generator for discrete distributions with given
  probability vector.
  It applies the Alias-Urn method (DAU).

  [Universal] -- Patchwork Method.
}

\usage{
dau.new(pv, from=1)
}
\arguments{
  \item{pv}{vector of non-negative numbers (need not sum to 1). (numeric vector)}
  \item{from}{index of first entry in vector. (integer)}
}

\details{
  These routines generate a sample of discrete random variates with
  given probability vector. This vector must be provided by
  \code{pv}, a vector of non-negative numbers which need not
  necessarily sum up to 1.
  
  It implements the \emph{Alias-Urn} method (DAU).

  The method runs fast in constant time, i.e., marginal sampling
  times do not depend on the length of the given probability vector.
  Whereas their setup times grow linearly with this length.
  
  Notice that the range of random variates is \code{from:(from+length(pv)-1)}!
}

\seealso{
  \code{\link{ur}}, \code{\link{unuran.new}}, \code{\linkS4class{unuran}}.
}

\references{
  W. H\"ormann, J. Leydold, and G. Derflinger (2004):
  Automatic Nonuniform Random Variate Generation.
  Springer-Verlag, Berlin Heidelberg.

  A.J. Walker (1977):
  An efficient method for generating discrete random variables with
  general distributions.
  ACM Trans. Model. Comput. Simul. 3, pp.253--256.
}

\author{
  Josef Leydold and Wolfgang H\"ormann
  \email{unuran@statmath.wu-wien.ac.at}.
}

\examples{
## Create a sample of size 100 for a 
## binomial distribution with size=115, prob=0.5
gen <- dau.new(pv=dbinom(0:115,115,0.5))
x <- ur(gen,100)
}

\keyword{distribution}
\keyword{datagen}

