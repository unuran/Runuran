#############################################################################
##                                                                         ##
##   Runuran                                                               ##
##                                                                         ##
##   (c) 2007, Josef Leydold and Wolfgang Hoermann                         ##
##   Department for Statistics and Mathematics, WU Wien                    ##
##                                                                         ##
#############################################################################
##                                                                         ##
##   Wrapper for UNU.RAN sampling methods                                  ##
##                                                                         ##
##   Interface to the UNU.RAN library for                                  ##
##   Universal Non-Uniform RANdom variate generators                       ##
##                                                                         ##
#############################################################################

#############################################################################
##                                                                          #
## Auxiliary functions                                                      #
##                                                                          #
#############################################################################

## -- Numerical derivative --------------------------------------------------

numerical.derivative <- function (x, func, lb=-Inf, ub=Inf, xmin=1, delta=1.e-7) {
        ## x      ... argument
        ## func   ... function for which derivative has to bee computed
        ## lb, ub ... domain of 'func' (not implemented yet)
        ## xmin   ... (not implemented yet)
        ## delta  ... delta for computing difference
        h <- pmax(x*delta,delta)
        df <- (func(x+h)-func(x-h))/(2*h)
}


#############################################################################
##                                                                          #
## Sampling methods for continuous univariate Distributions                 #
##                                                                          #
#############################################################################

## -- ARS: Adaptive Rejection Sampling (TDR with T=log) ---------------------
##
## Type: Acceptance-Rejection
##
## Generate continuous random variates from a given PDF
##

ars.new <- function (logpdf, dlogpdf=NULL, lb=-Inf, ub=Inf, ...) {
        ## the probability density function is obligatory and must be a function

        if (missing(logpdf))
                stop ("argument 'logpdf' required")
        if (! is.function(logpdf))
                stop ("argument 'logpdf' must be of class 'function'")
        f <- function(x) logpdf(x, ...) 

        ## we also need the derivative of the PDF
        if (is.null(dlogpdf)) {
                ## use numerical derivative
                df <- function(x) {
                        numerical.derivative(x,f)
                }
        }
        else {
                if (! is.function(dlogpdf) )
                        stop ("argument 'dlogpdf' must be of class 'function'")
                else df <- function(x) dlogpdf(x,...)
	}	

        ## S4 class for continuous distribution
        dist <- new("unuran.cont", pdf=f, dpdf=df, lb=lb, ub=ub, islog=TRUE)

        ## create and return UNU.RAN object
        unuran.new(dist, "ars")
}


## -- TDR: Transformed Density Rejection ------------------------------------
##
## Type: Acceptance-Rejection
##
## Generate continuous random variates from a given PDF
##

tdr.new <- function (pdf, dpdf=NULL, lb=-Inf, ub=Inf, islog=FALSE, ...) {
        ## the probability density function is obligatory and must be a function

        if (missing(pdf))
                stop ("argument 'pdf' required")
        if (! is.function(pdf))
                stop ("argument 'pdf' must be of class 'function'")
        f <- function(x) pdf(x, ...) 

        ## we also need the derivative of the PDF
        if (is.null(dpdf)) {
                ## use numerical derivative
                df <- function(x) {
                        numerical.derivative(x,f)
                }
        }
        else {
                if (! is.function(dpdf) )
                        stop ("argument 'dpdf' must be of class 'function'")
                else df <- function(x) dpdf(x,...)
	}	

        ## S4 class for continuous distribution
        dist <- new("unuran.cont", pdf=f, dpdf=df, lb=lb, ub=ub, islog=islog)

        ## create and return UNU.RAN object
        unuran.new(dist, "tdr")
}


#############################################################################
##                                                                          #
## Sampling methods for discrete univariate Distributions                   #
##                                                                          #
#############################################################################

## -- DAU: Alias-Urn Method ------------------------------------------------
##
## Type: Patchwork
##
## Generate discrete random variates from a given probability vector
## using the Alias-Urn Method
##
## Remark: we do not pass the domain to UNU.RAN
##

dau.new <- function (pv, from=1) {
        ## the probability vector is obligatory
        if (missing(pv))
                stop ("argument 'pv' required")
        if (!is.numeric(pv))
                stop ("argument 'pv' must be of class 'numeric'")

        ## S4 class for discrete distribution
        distr <- new("unuran.discr",pv=pv,lb=from)

        ## create and return UNU.RAN object
        new("unuran", distr, "DAU")
}

## -- DGT: Guide Table Method -----------------------------------------------
##
## Type: Inversion
##
## Generate discrete random variates from a given probability vector
## using the Guide-Table Method for discrete inversion
##
## Remark: we do not pass the domain to UNU.RAN
##

dgt.new <- function (pv, from=1) {
        ## the probability vector is obligatory
        if (missing(pv))
                stop ("argument 'pv' required")
        if (!is.numeric(pv))
                stop ("argument 'pv' must be of class 'numeric'")

        ## S4 class for discrete distribution
        distr <- new("unuran.discr",pv=pv,lb=from)

        ## create and return UNU.RAN object
        new("unuran", distr, "DGT")
}


#############################################################################
##                                                                          #
## Sampling methods for continuous multivariate Distributions               #
##                                                                          #
#############################################################################


## -- HITRO: Hit-and-Run sampler with Ratio-of-Uniforms ---------------------
##
## Type: MCMC
##
## Generate continuous random variates from a given PDF
##

hitro.new <- function (dim=1, pdf, mode=NULL, center=NULL, ll=NULL, ur=NULL, thinning=1, burnin=0, ...) {
        ## the probability density function is obligatory and must be a function
        if (missing(pdf))
                stop ("argument 'pdf' required")
        if (! is.function(pdf))
                stop ("argument 'pdf' must be of class 'function'")
        f <- function(x) pdf(x, ...) 

        ## S4 class for continuous multivariate distribution
        dist <- new("unuran.cmv", dim=dim, pdf=f, mode=mode, center=center, ll=ll, ur=ur)

        ## create and return UNU.RAN object
        method <- paste("hitro;thinning=",thinning,";burnin=",burnin, sep="")
        unuran.new(dist, method)
}

## -- End -------------------------------------------------------------------
