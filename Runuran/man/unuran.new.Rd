\name{urnorm}
\docType{function}

\alias{unuran.new}

\title{unuran.new: creating a "unuran" object}

\description{ Creates an "unuran" object that can be used
   for sampling from the specified distribution.
   The function \code{unuran.sample(unuran.object,sample.size)} 
   requires that "unuran" object.
  
}

\usage{ new( "unuran", dist.string, method.string) }

}
\arguments{
  \item{distr.string}{a string describing the distibution}
  \item{method.string}{a string describing the random variate generation method}
}

\details{

dist.string:  Describes the distribution that should be sampled
   \describe{
     \item{Standard distributions:}{ There are functions like urnorm(),
        urgamma(), urpareto() available for sampling from all built-in
        standard distributions of unuran.}
     \item{Continuous distributions:}{ dist.string has to start with 
      "distr=cont;" then "pdf='1/x^2';" can be eg. used to specify
       the density; "domain = (1, Inf)" to specify the domain of the
       distribution. Thus we can use 

       distr.string = "distr=cont; pdf='1/x^3'; domain = (0.5, Inf)"

       to define a distribution with density proportional to \eqn{1/x^3}$
       on the interval (0.5, Inf). As we have only defined the pdf
       of the distribution we have to use the method "TDR" (see below); as
       it is based on rejection it is not necessary that the
       integral of the density is equal to 1.

       distr.string = "distr=cont; pdf='log(x)*(x < 1.3098)+(x > 1.3098)*exp(-x)'; domain = (1, 5)"
       can be used to specify a density on (1,5) with mode at 1.3098.


       distr.string = "distr=cont; pdf='x^3/3'; cdf='x^4'; domain = (0, 1)"
       can be used to specify a distribution with the given PDF and CDF. 
       Note that when the CDF is specified as well it is necessary that the
       density has integral one. If the CDF is specified the numerical
       inversion method "HINV" can be used (see below).
     }      

     \item{Discrete distributions:}{ For most discrete distributions it is 
           easier to use the functions urdgt() and urdau(). For the case
           that the pmf is unimodal and has a very heavy tail the following
            example may be useful:

          distr.string = "distr=discr; pmf='1/(2+x)^2.1'; domain = (1, Inf); pmfsum = 0.05"
          As this distribution has a very heavy tail we have to use the rejection
          method DARI which needs an estimate for the sum of the pmf. 0.05 is 
          not the exact value here; a very crude estimate like e.g. 1 can be used as well.
      }
     \item{mode}{After a semicolon we can add to the distribution 
           string "mode = ." to inform unuran about the mode
           of a distribution. This is useful for the method "TDR" but not for 
           "HINV". It also works for discrete distributions and is useful for DARI
            but not for DGT and DAU.
       }


}   


method.string:  Describes the method that should be used for sampling

  Continuous and discrete distributions require different generation methods.

  For continuous distributions the most important selections are:
  \describe{
    \item{"HINV":}{ Fast numerical inversion using a piecewise polynomial
      interpolation of the inverse CDF; requires the CDF.}
    \item{"HINV; u_resolution=1.e-12"}{can be used to increase the maximal tolerated
      u-error (i.e. |U-CDF(X)|)
      of the numeric inversion. (default is 1.e-10).
    }
    \item{"TDR":}{ Transformed density rejection; requires the density;
      works only for T_{-0.5}-concave distributions (ie. unimodal densities
      with tails not higher than \eqn{(1/x^2)}).
      Decomposes the density into
      subintervals and uses a seperate hat proportional to \eqn{1/(c+x^2)} for
      each subinterval; the number of subintervals is selected such that
      the acceptance probability is about 99\% .}
    \item{"TDR; c=0":}{Uses a picewise exponential hat instead. 
       Only useable if the 
      distribution is log-concave. Is slower than the default.}
    \item{"TDR; max_sqhratio=0.95":}{Approximate acceptance probability 
      set to 0.95.}
    
  }

  For discrete distributions the most important selections are:

  \describe{
    \item{"DGT":}{Guide table method for discrete inversion. Works only
      if the number of non negligable probabilities is not too large.}
    \item{"DAU":}{Alias-Urn method. Works only
      if the number of non negligable probabilities is not too large.}
    \item{"DARI":}{Automatic rejection inversion. Uses a discrete
      rejection algorithm. Works only for unimodal discrete distributions with
      tails not higher than \eqn{1/x^2}.}
    
  }

}




\seealso{
  \code{\link{runif}} and \code{\link{.Random.seed}} about random number
  generation, \code{\link{unuran-class}} for the UNU.RAN class, 
  \code{\link{unuran.sample}},   \code{\link{urdgt}} and   
  \code{\link{urdau}}.
}

\references{
  W. H\"ormann, J. Leydold, and G. Derflinger (2004):
  Automatic Nonuniform Random Variate Generation.
  Springer-Verlag, Berlin Heidelberg
}

\author{
  Josef Leydold \email{leydold@statmath.wu-wien.ac.at} and
  Wolfgang H\"ormann \email{hormannw@boun.edu.tr}
}


\examples{
## Make histograms for samples of size 10000 for some non-standard distributions

unr <- new("unuran", "distr=cont; pdf='log(x)*(x<1.3098)+(x>1.3098)*exp(-x)'; domain = (1, Inf)","TDR");
x <- unuran.sample(unr,10000);
hist(x)


unr <- new("unuran", "distr=cont; pdf='1/x^3'; domain = (0.5, Inf)","TDR");
x <- unuran.sample(unr,10000);
hist(x)

unr <- new("unuran", "distr=discr; pmf='1/(2+x)^3'; domain = (1, Inf);pmfsum=0.05","DARI");
x <- unuran.sample(unr,10000);
hist(x)


}

\keyword{distribution}
\keyword{datagen}

