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
## Sampling methods for discrete univariate Distributions                   #
#############################################################################

## -- DGT: Guide Table Method -----------------------------------------------
##
## Type: Inversion
##
## Generate discrete random variates from a given probability vector
## useing the Guide-Table Method for discrete inversion
##

urdgt <- function (n, probvector, minval = 0, dist = 1) {
        ## very fast for probvector not longer than about 1000

        distrstring <- paste("distr=discr;pv=(",
                             paste(probvector,collapse=",",sep=""),")",sep="")
        unr <- new("unuran", distrstring, "DGT")
        if (minval==0 & dist==1)
                unuran.sample(unr,n)
        else
                minval + dist * unuran.sample(unr,n)
}

## -- DAU: Alias-Urn Method ------------------------------------------------
##
## Type: Patchwork
##
## Generate discrete random variates from a given probability vector
## useing the Alias-Urn Method
##

urdau <- function (n, probvector, minval = 0, dist = 1) {
        ## very fast for probvector not longer than about 1000
        distrstring <- paste("distr=discr;pv=(",
                             paste(probvector,collapse=",",sep=""),")",sep="")
        unr <- new("unuran", distrstring, "DAU")
        if (minval==0 & dist==1)
                unuran.sample(unr,n)
        else
                minval + dist * unuran.sample(unr,n)
}

## -- End -------------------------------------------------------------------


