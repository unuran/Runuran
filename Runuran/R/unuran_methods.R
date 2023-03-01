#############################################################################
##                                                                         ##
##   Runuran                                                               ##
##                                                                         ##
##   (c) 2007, Josef Leydold and Wolfgang Hoermann                         ##
##   Department for Statistics and Mathematics, WU Wien                    ##
##                                                                         ##
#############################################################################
##                                                                         ##
##   Wrapper for special UNU.RAN sampling methods                          ##
##                                                                         ##
##   Interface to the UNU.RAN library for                                  ##
##   Universal Non-Uniform RANdom variate generators                       ##
##                                                                         ##
#############################################################################

#############################################################################
##                                                                          #
## Sampling methods for continuous univariate Distributions                 #
##                                                                          #
#############################################################################

## -- TDR: Transformed Density Rejection ------------------------------------
##
## Type: Acceptance-Rejection
##
## Generate continuous random variates from a given PDF
##

urtdr <- function (n, pdf, dpdf, lb=-Inf, ub=Inf, islog=TRUE, ...) {
        ## the probability density function is obligatory and must be a function
        if (missing(pdf))
                stop ("argument 'pdf' required")
        if (! is.function(pdf))
                stop ("argument 'pdf' must be of class 'function'")
        f <- function(x) pdf(x, ...) 
        ## we also need the derivative of the PDF
        if (missing(dpdf)) {
                ## use numerical derivative
                dpdf <- function(x) {
                        numerical.derivative(x,f)
                }
        }
        if (! is.function(dpdf) )
                stop ("argument 'dpdf' must be of class 'function'")
        ## S4 class for discrete distribution
        dist <- new("unuran.cont", pdf=pdf, dpdf=dpdf, lb=lb, ub=ub, islog=islog)
        ## create UNU.RAN object
        unr <- unuran.new(dist, "tdr")
        ## draw sample
        unuran.sample(unr,n)
}

numerical.derivative <- function (x, func, lb=-Inf, ub=Inf, xmin=1, delta=1.e-7) {
        h <- pmax(x*delta,delta)
        df <- (func(x+h)-func(x-h))/(2*h)
}

#############################################################################
##                                                                          #
## Sampling methods for discrete univariate Distributions                   #
##                                                                          #
#############################################################################

## -- DGT: Guide Table Method -----------------------------------------------
##
## Type: Inversion
##
## Generate discrete random variates from a given probability vector
## using the Guide-Table Method for discrete inversion
##
## Remark: we do not pass the domain to UNU.RAN
##

urdgt <- function (n, probvector, from = 0, by = 1) {
        ## the probability vector is obligatory
        if (missing(probvector))
                stop ("argument 'probvector' required")
        if (!is.numeric(probvector))
                stop ("argument 'probvector' must be of class 'numeric'")
        ## S4 class for discrete distribution
        distr <- new("unuran.discr",pv=probvector)
        ## create UNU.RAN object
        unr <- new("unuran", distr, "DGT")
        ## draw sample
        if (from==0 && by==1)
                unuran.sample(unr,n)
        else
                from + by * unuran.sample(unr,n)
}

## -- DAU: Alias-Urn Method ------------------------------------------------
##
## Type: Patchwork
##
## Generate discrete random variates from a given probability vector
## using the Alias-Urn Method
##
## Remark: we do not pass the domain to UNU.RAN
##

urdau <- function (n, probvector, from = 0, by = 1) {
        ## the probability vector is obligatory
        if (missing(probvector))
                stop ("argument 'probvector' required")
        if (!is.numeric(probvector))
                stop ("argument 'probvector' must be of class 'numeric'")
        ## S4 class for discrete distribution
        distr <- new("unuran.discr",pv=probvector)
        ## create UNU.RAN object
        unr <- new("unuran", distr, "DAU")
        ## draw sample
        if (from==0 && by==1)
                unuran.sample(unr,n)
        else
                from + by * unuran.sample(unr,n)
}

## -- End -------------------------------------------------------------------


