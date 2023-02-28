\name{unuran.sample-methods}
\docType{methods}

\alias{unuran.sample-methods}
\alias{unuran.sample}
\alias{unuran.sample,unuran-method}
\alias{unuran.sample,unuran,numeric-method}
\alias{r}
\alias{r,unuran-method}
\alias{r,unuran,numeric-method}

\title{Methods for Function unuran.sample in Package `Runuran'}
\description{
  Get random sample from an "unuran" object in package
  \pkg{Runuran}.
}

\usage{
\S4method{unuran.sample}{unuran,numeric}(unur,n=1)
\S4method{r}{unuran,numeric}(unur,n=1)
}
\arguments{
  \item{unur}{an "unuran" object.}
  \item{n}{sample size.}
}

\seealso{%
  \code{\link{unuran-class}}.
}

\note{\code{r} is equivalent to \code{unuran.sample}.}

\author{Josef Leydold}

%%\examples{ }

\keyword{methods}
\keyword{distribution}
\keyword{datagen}
