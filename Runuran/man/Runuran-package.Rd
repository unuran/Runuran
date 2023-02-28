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

  It provides the following two main calls:
  \describe{
    \item{\code{new("unuran",dist.string,method.string)}}{
      Create a "unuran" object. For details see unuran.new.
    }
    \item{\code{unuran.sample(unuran.object,sample.size)}}{
      Get a random sample from the stream object.
    }
  }
  It uses the \R built-in uniform random number generator.

  The functions urdgt() and urdau() are provided to allow an easy
  interface when generating from discrete distributions.

  To facilitate the use of the package for standard distributions
  the package also includes direct generation functions for
  approximately 30 standard distributions. The names of these calls are:

  urbeta() ,
urburr() ,
urcauchy() ,
urchi() ,
urchisq() ,
urexp() ,
urextremeI() ,
urextremeII() ,
urf() ,
urgamma() ,
urgig() ,
urhyperbolic() ,
urlaplace() ,
urlnorm() ,
urlogis() ,
urlomax() ,
urnorm() ,
urpareto() ,
urplanck() ,
urpowerexponential() ,
urrayleigh() ,
urt() ,
urtriang() ,
urweibull() ,
urbinom() ,
urgeom() , 
urhyper() ,
urlogarithmic() ,
urnbinom() ,
urpois() 


  All calls are based on the syntax:

  ur...(n, ... distribution parameters ..., lb , ub)

  We also include unuran "ur" - fuctions for standard distributions included in R
  as they have a slightly different behaviour than the 
  random variate generation functions of R like "rnorm". 
  \describe{
    \item{}{"ur" functions are often much faster (e.g. a factor) of about 5 for the  
      t distribution when n is large. For n small the "ur" functions are slow.}
    \item{}{All "ur" functions allow to generate truncated versions of
      the original distributions. Therefore the arguments lb (lower border)
      and ub (upper border) are available for all "ur" functions.}
    \item{}{Allmost all "ur" functions are based on fast numerical inversion
      algorithms. This is important for example for generating
      order statistics or random vectors from copulas.}
    \item{}{All "ur" functions do NOT allow vectors as arguments.}
  }
}


  

\note{
  The interface has been changed compared to the DSC 2003 paper.
} 

\author{
  Josef Leydold \email{leydold@statmath.wu-wien.ac.at} and
  Wolfgang H\"ormann \email{hormannw@boun.edu.tr}
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
  \code{\link{unuran.new}}, \link[Runuran:unuran-class]{unuran-class}, \code{\link{urdgt}}
  and \code{\link{urdau}}.
}

\keyword{distribution}
\keyword{datagen}

