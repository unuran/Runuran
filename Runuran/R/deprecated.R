#############################################################################
##                                                                         ##
##   Runuran                                                               ##
##                                                                         ##
##   (c) 2007, Josef Leydold and Wolfgang Hoermann                         ##
##   Department for Statistics and Mathematics, WU Wien                    ##
##                                                                         ##
#############################################################################
##                                                                         ##
##   Deprecated functions!                                                 ##
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
## DEPRECATED!
## use function 'ur(tdr.new(...),n)' instead.

urtdr <- function (n, pdf, dpdf=NULL, lb=-Inf, ub=Inf, islog=TRUE, ...) {
        ## create UNU.RAN object
        unr <- tdr.new(pdf=pdf,dpdf=dpdf,lb=lb,ub=ub,islog=islog,...)
        ## draw sample
        unuran.sample(unr,n)
}


## -- HINV: Hermite interpolation for approximate INVersion -----------------
##
## Type: Inversion
##
## Generate continuous random variates from a given CDF/PDF
##

## DEPRECATED!
## use function 'uq' instead.

## Quantile function
uqhinv <- function (unr, U) { uq(unr,U) }


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
## DEPRECATED!

urdgt <- function (n, probvector, from = 0, by = 1) {
        ## create UNU.RAN object
        unr <- dgt.new(pv=probvector, from=0)
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
## DEPRECATED!

urdau <- function (n, probvector, from = 0, by = 1) {
        ## create UNU.RAN object
        unr <- dau.new(pv=probvector, from=0)
        ## draw sample
        if (from==0 && by==1)
                unuran.sample(unr,n)
        else
                from + by * unuran.sample(unr,n)
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
## DEPRECATED!

urhitro <- function (n, dim=1, pdf, mode=NULL, center=NULL, ll=NULL, ur=NULL, thinning=1, burnin=0, ...) {
        ## create UNU.RAN object
        unr <- hitro.new(dim=dim, pdf=pdf, mode=mode, center=center, ll=ll, ur=ur,
                         thinning=thinning, burnin=burnin, ...)
        ## draw sample
        unuran.sample(unr,n)
}


## -- End -------------------------------------------------------------------
