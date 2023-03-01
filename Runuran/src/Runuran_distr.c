/*****************************************************************************
 *                                                                           *
 *          UNU.RAN -- Universal Non-Uniform Random number generator         *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   FILE: Runuran_distr.c                                                   *
 *                                                                           *
 *   PURPOSE:                                                                *
 *         R interface to UNU.RAN distribution objects                       *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   Copyright (c) 2007 Wolfgang Hoermann and Josef Leydold                  *
 *   Dept. for Statistics, University of Economics, Vienna, Austria          *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   59 Temple Place, Suite 330, Boston, MA 02111-1307, USA                  *
 *                                                                           *
 *****************************************************************************/

/*---------------------------------------------------------------------------*/

#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

#include "Runuran.h"
#include <unuran.h>

/*---------------------------------------------------------------------------*/

/* structure for storing pointers to R objects                               */
struct Runuran_distr_cont {
  SEXP env;                 /* R environment                                 */
  SEXP cdf;                 /* CDF of distribution                           */
  SEXP pdf;                 /* PDF of distribution                           */
  SEXP dpdf;                /* derivative of PDF of distribution             */
};

/*---------------------------------------------------------------------------*/
/*  Discrete Distributions (DISCR)                                           */

/*---------------------------------------------------------------------------*/
/*  Continuous Univariate Distributions (CONT)                               */

static double _Runuran_cont_eval_cdf( double x, const struct unur_distr *distr );
/* Evaluate CDF function.                                                    */

static double _Runuran_cont_eval_pdf( double x, const struct unur_distr *distr );
/* Evaluate PDF function.                                                    */

static double _Runuran_cont_eval_dpdf( double x, const struct unur_distr *distr );
/* Evaluate derivative of PDF function.                                      */

/*---------------------------------------------------------------------------*/
/*  Common Routines                                                          */

static void _Runuran_distr_free(SEXP sexp_distr);
/* Free UNU.RAN distribution object.                                         */

/*---------------------------------------------------------------------------*/

#define _Runuran_fatal()  errorcall_return(R_NilValue,"[UNU.RAN - error] cannot create UNU.RAN distribution object")

/*---------------------------------------------------------------------------*/

/* Check pointer to generator object */
#define CHECK_PTR(s) do { \
    if (TYPEOF(s) != EXTPTRSXP || R_ExternalPtrTag(s) != _Runuran_distr_tag) \
        error("[UNU.RAN - error] invalid UNU.RAN distribution object"); \
    } while (0)

/* Use an external reference to store the UNU.RAN generator objects */
static SEXP _Runuran_distr_tag = NULL;


/*****************************************************************************/
/*                                                                           */
/*  Discrete Distributions (DISCR)                                           */
/*                                                                           */
/*****************************************************************************/

SEXP
Runuran_discr_init (SEXP sexp_pv)
     /*----------------------------------------------------------------------*/
     /* Create and initialize UNU.RAN object for discrete distribution.      */
     /*----------------------------------------------------------------------*/
{
  SEXP sexp_distr;
  struct unur_distr *distr;
  const double *pv;
  int n_pv;

  /* make tag for R object */
  if (!_Runuran_distr_tag) _Runuran_distr_tag = install("R_UNURAN_DISTR_TAG");

  /* check argument */
  if (!sexp_pv || TYPEOF(sexp_pv) != REALSXP)
    errorcall_return(R_NilValue,"[UNU.RAN - error] invalid argument 'pv'");

  /* get probability vector */
  pv = REAL(sexp_pv);
  n_pv = length(sexp_pv);

  /* create distribution object */
  distr = unur_distr_discr_new();
  if (unur_distr_discr_set_pv(distr,pv,n_pv) != UNUR_SUCCESS) {
    unur_distr_free(distr);
    _Runuran_fatal();
  }

  /* make R external pointer and store pointer to structure */
  PROTECT(sexp_distr = R_MakeExternalPtr(distr, _Runuran_distr_tag, R_NilValue));
  UNPROTECT(1);
  
  /* register destructor as C finalizer */
  R_RegisterCFinalizer(sexp_distr, _Runuran_distr_free);

  /* return pointer to R */
  return (sexp_distr);

} /* end of Runuran_discr_init() */


/*****************************************************************************/
/*                                                                           */
/*  Continuous Univariate Distributions (CONT)                               */
/*                                                                           */
/*****************************************************************************/

SEXP
Runuran_cont_init (SEXP sexp_this, SEXP sexp_env, 
		   SEXP sexp_cdf, SEXP sexp_pdf, SEXP sexp_dpdf, SEXP sexp_islog,
		   SEXP sexp_domain)
     /*----------------------------------------------------------------------*/
     /* Create and initialize UNU.RAN object for continuous distribution.    */
     /*                                                                      */
     /* Parameters:                                                          */
     /*   this   ... pointer to S4 class containing this object              */
     /*   env    ... R environment                                           */
     /*   cdf    ... CDF of distribution                                     */
     /*   pdf    ... PDF of distribution                                     */
     /*   dpdf   ... derivative of PDF of distribution                       */
     /*   islog  ... boolean: TRUE if logarithms of CDF|PDF|dPDF are given   */
     /*   domain ... domain of distribution                                  */
     /*----------------------------------------------------------------------*/
{
  SEXP sexp_distr;
  struct Runuran_distr_cont *Rdistr;
  struct unur_distr *distr;
  const double *domain;
  int islog;
  unsigned int error = 0u;

  /* make tag for R object */
  if (!_Runuran_distr_tag) _Runuran_distr_tag = install("R_UNURAN_DISTR_TAG");

#ifdef RUNURAN_DEBUG
  /* 'this' must be an S4 class */
  if (!IS_S4_OBJECT(sexp_this))
    errorcall_return(R_NilValue,"[UNU.RAN - error] invalid object");

  /* all other variables are tested in the R routine */
  /* TODO: add checks in DEBUGging mode */
#endif

  /* domain of distribution */
  if (! (sexp_domain && TYPEOF(sexp_domain)==REALSXP && length(sexp_domain)==2) )
    errorcall_return(R_NilValue,"[UNU.RAN - error] invalid argument 'domain'");
  domain = REAL(sexp_domain);

  /* whether we are given logarithm of CDF|PDF|dPDF or not */
  islog = LOGICAL(sexp_islog)[0];

  /* store pointers to R objects */
  Rdistr = Calloc(1,struct Runuran_distr_cont);
  Rdistr->env = sexp_env;
  Rdistr->cdf = sexp_cdf;
  Rdistr->pdf = sexp_pdf;
  Rdistr->dpdf = sexp_dpdf;

  /* create distribution object */
  distr = unur_distr_cont_new();
  if (distr == NULL) _Runuran_fatal();

  /* set domain */
  error |= unur_distr_cont_set_domain( distr, domain[0], domain[1] );

  /* set function pointers */
  error |= unur_distr_set_extobj(distr, Rdistr);
  if (islog) {
    if (!isNull(sexp_cdf))
      error |= unur_distr_cont_set_logcdf(distr, _Runuran_cont_eval_cdf);
    if (!isNull(sexp_pdf))
      error |= unur_distr_cont_set_logpdf(distr, _Runuran_cont_eval_pdf);
    if (!isNull(sexp_dpdf))
      error |= unur_distr_cont_set_dlogpdf(distr, _Runuran_cont_eval_dpdf);
  }
  else {
    if (!isNull(sexp_cdf))
      error |= unur_distr_cont_set_cdf(distr, _Runuran_cont_eval_cdf);
    if (!isNull(sexp_pdf))
      error |= unur_distr_cont_set_pdf(distr, _Runuran_cont_eval_pdf);
    if (!isNull(sexp_dpdf))
      error |= unur_distr_cont_set_dpdf(distr, _Runuran_cont_eval_dpdf);
  }

  /* check return codes */
  if (error) {
    unur_distr_free (distr); 
    _Runuran_fatal();
  } 

  /* make R external pointer and store pointer to structure */
  PROTECT(sexp_distr = R_MakeExternalPtr(distr, _Runuran_distr_tag, R_NilValue));
  UNPROTECT(1);
  
  /* register destructor as C finalizer */
  R_RegisterCFinalizer(sexp_distr, _Runuran_distr_free);

  /* return pointer to R */
  return (sexp_distr);

} /* end of Runuran_cont_init() */

/*---------------------------------------------------------------------------*/

double
_Runuran_cont_eval_cdf( double x, const struct unur_distr *distr )
     /*----------------------------------------------------------------------*/
     /* Evaluate CDF function.                                               */
     /*----------------------------------------------------------------------*/
{
  const struct Runuran_distr_cont *Rdistr;
  SEXP R_fcall, arg;
  double y;

  Rdistr = unur_distr_get_extobj(distr);
  PROTECT(arg = NEW_NUMERIC(1));
  NUMERIC_POINTER(arg)[0] = x;
  PROTECT(R_fcall = lang2(Rdistr->cdf, R_NilValue));
  SETCADR(R_fcall, arg);
  y = REAL(eval(R_fcall, Rdistr->env))[0];
  UNPROTECT(2);
  return y;
} /* end of _Runuran_cont_eval_cdf() */

/*---------------------------------------------------------------------------*/

double
_Runuran_cont_eval_pdf( double x, const struct unur_distr *distr )
     /*----------------------------------------------------------------------*/
     /* Evaluate PDF function.                                               */
     /*----------------------------------------------------------------------*/
{
  const struct Runuran_distr_cont *Rdistr;
  SEXP R_fcall, arg;
  double y;

  Rdistr = unur_distr_get_extobj(distr);
  PROTECT(arg = NEW_NUMERIC(1));
  NUMERIC_POINTER(arg)[0] = x;
  PROTECT(R_fcall = lang2(Rdistr->pdf, R_NilValue));
  SETCADR(R_fcall, arg);
  y = REAL(eval(R_fcall, Rdistr->env))[0];
  UNPROTECT(2);
  return y;
} /* end of _Runuran_cont_eval_pdf() */

/*---------------------------------------------------------------------------*/

double
_Runuran_cont_eval_dpdf( double x, const struct unur_distr *distr )
     /*----------------------------------------------------------------------*/
     /* Evaluate derivative of PDF function.                                 */
     /*----------------------------------------------------------------------*/
{
  const struct Runuran_distr_cont *Rdistr;
  SEXP R_fcall, arg;
  double y;

  Rdistr = unur_distr_get_extobj(distr);
  PROTECT(arg = NEW_NUMERIC(1));
  NUMERIC_POINTER(arg)[0] = x;
  PROTECT(R_fcall = lang2(Rdistr->dpdf, R_NilValue));
  SETCADR(R_fcall, arg);
  y = REAL(eval(R_fcall, Rdistr->env))[0];
  UNPROTECT(2);
  return y;
} /* end of _Runuran_cont_eval_dpdf() */


/*****************************************************************************/
/*                                                                           */
/*  Common Routines                                                          */
/*                                                                           */
/*****************************************************************************/

void
_Runuran_distr_free (SEXP sexp_distr)
     /*----------------------------------------------------------------------*/
     /* Free UNU.RAN distribution object.                                    */
     /*----------------------------------------------------------------------*/
{
  struct unur_distr *distr;
  const void *Rdistr;

#ifdef DEBUG
  /* check pointer */
  CHECK_PTR(sexp_distr);
  printf("Runuran_distr_free called!\n");
#endif

  /* Extract pointer to distribution object */
  distr = R_ExternalPtrAddr(sexp_distr);

  /* free structure that stores R object */
  Rdistr = unur_distr_get_extobj(distr);
  Free(Rdistr);

  /* free distribution object */
  unur_distr_free(distr);

  R_ClearExternalPtr(sexp_distr);

} /* end of _Runuran_distr_free() */

/*---------------------------------------------------------------------------*/
