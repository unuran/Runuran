/*****************************************************************************
 *                                                                           *
 *          UNURAN -- Universal Non-Uniform Random number generator          *
 *                                                                           *
 *****************************************************************************/

/* R header files */
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>

/* UNU.RAN header files */
#include <unuran.h>

/*****************************************************************************/
/*                                                                           */
/*   R <--> C programming interface (used in .Call)                          */
/*   (public part)                                                           */
/*                                                                           */
/*****************************************************************************/

/*****************************************************************************/
/* Create and handle UNU.RAN distribution objects                            */

typedef SEXP RUNURAN_EXT_FUNCT_INIT
( SEXP sexp_obj, SEXP sexp_params, SEXP sexp_domain,
  UNUR_FUNCT_CONT *cdf, UNUR_FUNCT_CONT *pdf, UNUR_FUNCT_CONT *dpdf, int islog,
  double *mode, double *center, char *name );

RUNURAN_EXT_FUNCT_INIT Runuran_ext_cont_init;

/*---------------------------------------------------------------------------*/
/* Create and initialize UNU.RAN object for continuous distribution.         */
/*---------------------------------------------------------------------------*/
