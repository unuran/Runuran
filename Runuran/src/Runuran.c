/*****************************************************************************
 *                                                                           *
 *          UNURAN -- Universal Non-Uniform Random number generator          *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   FILE: Runuran.c                                                         *
 *                                                                           *
 *   PURPOSE:                                                                *
 *         R interface for unuran                                            *
 *                                                                           *
 *****************************************************************************
     $Id: Runuran.c,v 1.1 2003/03/18 09:34:50 leydold Exp $
 *****************************************************************************
 *                                                                           *
 *   Copyright (c) 2000 Wolfgang Hoermann and Josef Leydold                  *
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

#include <Runuran.h>
#include <unuran.h>

/*---------------------------------------------------------------------------*/

/* #define DEBUG 1 */

/*---------------------------------------------------------------------------*/

/* check pointer to generator object */
#define CHECK_PTR(s) do { \
    if (TYPEOF(s) != EXTPTRSXP || R_ExternalPtrTag(s) != R_unur_tag) \
        error("bad UNURAN object"); \
    } while (0)

/* Use an external reference to store the UNURAN generator objects */
static SEXP R_unur_tag = NULL;

/*---------------------------------------------------------------------------*/

SEXP R_unur_init (SEXP sexp_string)
     /*----------------------------------------------------------------------*/
     /* Create and initinalize unuran generator object.                      */
     /*----------------------------------------------------------------------*/
{
  SEXP sexp_gen;
  struct unur_gen *gen;
  const char *string;

  /* make tag for R object */
  if (!R_unur_tag) R_unur_tag = install("R_UNUR_TAG");

  /* check argument */
  if (!sexp_string || TYPEOF(sexp_string) != STRSXP)
    error("bad string");

  /* get pointer to argument string */
  string = CHAR(STRING_ELT(sexp_string,0));

  /* create generator object */
  gen = unur_str2gen( string );

  /* this must not be a NULL pointer */
  if (gen == NULL) {
    error("cannot create UNURAN object");
  }

  /* make R external pointer and store pointer to structure */
  PROTECT(sexp_gen = R_MakeExternalPtr(gen, R_unur_tag, R_NilValue));
  UNPROTECT(1);
  
  /* register destructor as C finalizer */
  R_RegisterCFinalizer(sexp_gen, R_unur_free);

  /* return pointer to R */
  return (sexp_gen);

} /* end of R_unur_init() */

/*---------------------------------------------------------------------------*/

SEXP R_unur_sample (SEXP sexp_gen, SEXP sexp_n)
     /*----------------------------------------------------------------------*/
     /* Sample from unuran generator object.                                 */
     /*----------------------------------------------------------------------*/
{
  int n = INTEGER (sexp_n)[0];
  struct unur_gen *gen;
  int i;
  SEXP res;

  /* check pointer */
  CHECK_PTR(sexp_gen);

  /* Extract pointer to generator */
  gen = R_ExternalPtrAddr(sexp_gen);
  
  /* this must not be a NULL pointer */
  if (gen == NULL)
    error("bad UNURAN object");

  /* generate random vector of length n */
  PROTECT(res = NEW_NUMERIC(n));
  for (i=0; i<n; i++)
    NUMERIC_POINTER(res)[i] = unur_sample_cont(gen);
  UNPROTECT(1);

  /* return result to R */
  return res;
 
} /* end of R_unur_sample() */

/*---------------------------------------------------------------------------*/

void R_unur_free(SEXP sexp_gen)
     /*----------------------------------------------------------------------*/
     /* Free unuran generator object.                                        */
     /*----------------------------------------------------------------------*/
{
  struct unur_gen *gen;

  /* check pointer */
  CHECK_PTR(sexp_gen);
  
# ifdef DEBUG
  printf("R_unur_free called!\n");
#endif

  /* Extract pointer to generator */
  gen = R_ExternalPtrAddr(sexp_gen);

  /* free generator object */
  unur_free(gen);

  R_ClearExternalPtr(sexp_gen);

} /* end of R_unur_free() */

/*---------------------------------------------------------------------------*/

