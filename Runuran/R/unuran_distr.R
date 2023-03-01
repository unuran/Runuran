#############################################################################
##                                                                         ##
##   Runuran                                                               ##
##                                                                         ##
##   (c) 2007, Josef Leydold and Wolfgang Hoermann                         ##
##   Department for Statistics and Mathematics, WU Wien                    ##
##                                                                         ##
#############################################################################
##                                                                         ##
##   Virtual Class: unuran.dist                                            ##
##                                                                         ##
##   Interface to the UNU.RAN library for                                  ##
##   Universal Non-Uniform RANdom variate generators                       ##
##                                                                         ##
#############################################################################

## Initialize global variables ----------------------------------------------

## Class --------------------------------------------------------------------

setClass( "unuran.distr", 
         ## slots:
         representation( 
                        distr   = "externalptr"    # pointer to UNU.RAN distribution object
                        ),
         ## defaults for slots
         prototype = list(
                 distr   = NULL
                 ),
         ## misc
         contains = "VIRTUAL"
         )


## Printing -----------------------------------------------------------------

## print strings of UNU.RAN object
setMethod( "print", "unuran.distr",
          function(x, ...) {
                  cat("\nObject is UNU.RAN distribution object\n\n")
          } )

setMethod( "show", "unuran.distr",
          function(object) { print(object) } )

## End ----------------------------------------------------------------------
