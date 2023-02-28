\name{Runuran-package}
\alias{Runuran-package}
\alias{Runuran}
\docType{package}

\title{
  Runuran -- R interface to Universal Non-Uniform RANdom variate
  generators library}

\description{
  R interface to the UNU.RAN library for Universal Non-Uniform RANdom
  variate generators}
}

\details{
  \tabular{ll}{
    Package: \tab Runuran       \cr
    Type:    \tab Package       \cr
    Version: \tab 0.3           \cr
    Date:    \tab 2007-05-03    \cr
    License: \tab GPL 2 or later\cr
  }
  This package provides an interface to the UNU.RAN library for universal
  non-uniform random number generators.

  It provides the following two calls:
  \describe{
    \item{\code{new("unuran",distring,methodstring)}}{
      Create a "unuran" object.
    }
    \item{\code{unuran.sample(unuranobject,samplesize)}}{
      Get a random sample from the stream object.
    }
  }
  It uses the \R built-in uniform random number generator.
}

\note{
  The interface has been changed compared to the DSC 2003 paper.
} 

\author{
  Josef Leydold \email{leydold@statmath.wu-wien.ac.at}
}

\references{
  J. Leydold and W. H\"ormann (2000-2007):
  UNU.RAN User Manual, see
  \url{http://statmath.wu-wien.ac.at/unuran/}.
  
  W.~H\"ormann, J.~Leydold, and G.~Derflinger (2004):
  Automatic Nonuniform Random Variate Generation.
  Springer-Verlag, Berlin Heidelberg

  G.~Tirler and J.~Leydold (2003):
  Automatic Nonuniform Random Variate Generation in \R.
  In: K.~Hornik and F.~Leisch, 
  Proceedings of the 3rd International Workshop on
  Distributed Statistical Computing (DSC~2003),
  March 20--22, Vienna, Austria.
}

\seealso{
  \code{\link[Runuran:unuran-class]{unuran-class}},
%%  \code{\link[rstream:rstream-package]{rstream}}
}

\keyword{distribution}
\keyword{datagen}

