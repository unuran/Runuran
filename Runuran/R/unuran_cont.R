#############################################################################
##                                                                         ##
##   Runuran                                                               ##
##                                                                         ##
##   (c) 2007, Josef Leydold and Wolfgang Hoermann                         ##
##   Department for Statistics and Mathematics, WU Wien                    ##
##                                                                         ##
#############################################################################
##                                                                         ##
##   Class: unuran.cont                                                    ##
##                                                                         ##
##   Interface to the UNU.RAN library for                                  ##
##   Universal Non-Uniform RANdom variate generators                       ##
##                                                                         ##
#############################################################################

## Initialize global variables ----------------------------------------------

## Class --------------------------------------------------------------------

setClass( "unuran.cont", 
         ## slots:
         representation( 
                        distr   = "externalptr"    # pointer to UNU.RAN distribution object
                        ),
         ## defaults for slots
         prototype = list(
                 distr   = NULL
                 ),
         ## misc
         sealed = TRUE
         )

## Initialize ---------------------------------------------------------------

setMethod( "initialize", "unuran.cont",
          function(.Object, cdf=NULL, pdf=NULL, dpdf=NULL, islog=FALSE, lb=-Inf, ub=Inf) {
                  ## pv ... probability vector

                  ## Check entries
                  if(! (is.numeric(lb) && is.numeric(ub) && lb < ub) )
                          stop("invalid domain ('lb','ub')", call.=FALSE)

                  if(! (is.null(cdf) || is.function(cdf)) )
                          stop("invalid argument 'cdf'", call.=FALSE)
                  if(! (is.null(pdf) || is.function(pdf)) )
                          stop("invalid argument 'pdf'", call.=FALSE)
                  if(! (is.null(dpdf) || is.function(dpdf)) )
                          stop("invalid argument 'dpdf'", call.=FALSE)

                  if(!is.logical(islog))
                          stop("argument 'islog' must be boolean", call.=FALSE)

                  ## Store informations 
                  ## (currently nothing to do)

                  ## Create UNUR_DISTR object
                  .Object@distr <-.Call("Runuran_cont_init",
                                        .Object, new.env(),
                                        cdf, pdf, dpdf, islog,
                                        c(lb,ub),
                                        PACKAGE="Runuran")

                  ## Check UNU.RAN object
                  if (is.null(.Object@distr)) {
                          stop("Cannot create UNU.RAN distribution object", call.=FALSE)
                  }

                  ## return new UNU.RAN object
                  .Object
          } )

## Validity -----------------------------------------------------------------

## Sampling -----------------------------------------------------------------

## Printing -----------------------------------------------------------------

## print strings of UNU.RAN object
setMethod( "print", "unuran.cont",
          function(x, ...) {
                  cat("\nObject is UNU.RAN distribution object\n\n")
} )

setMethod( "show", "unuran.cont",
          function(object) { print(object) } )

## End ----------------------------------------------------------------------