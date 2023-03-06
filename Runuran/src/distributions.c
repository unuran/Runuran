/*****************************************************************************
 *                                                                           *
 *          UNU.RAN -- Universal Non-Uniform Random number generator         *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   FILE: distributions.h                                                   *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   Copyright (c) 2009 Wolfgang Hoermann and Josef Leydold                  *
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

#include <unuran.h>
#include "Runuran.h"

/*****************************************************************************/
/* Continuous distribution                                                   */

UNUR_DISTR *
_Runuran_get_std_cont( const char *name, const double *params, int n_params )
     /*----------------------------------------------------------------------*/
     /* Create UNU.RAN object for special continuous distribution.           */
     /*                                                                      */
     /* Parameters:                                                          */
     /*   name     ... name of special distribution                          */
     /*   params   ... vector of parameter values                            */
     /*   n_params ... number of parameters                                  */
     /*----------------------------------------------------------------------*/
{
  switch (name[0]) {
  case 'n':
    if ( !strcmp( name, "norm") )
      return unur_distr_normal (params,n_params);
    break;
  }

  /* unknown distribution */
  return NULL;
} /* _Runuran_get_std_cont() */
 
/*****************************************************************************/
/* Discrete distribution                                                     */

UNUR_DISTR *
_Runuran_get_std_discr( const char *name, const double *params, int n_params )
     /*----------------------------------------------------------------------*/
     /* Create UNU.RAN object for special discrete distribution.             */
     /*                                                                      */
     /* Parameters:                                                          */
     /*   name     ... name of special distribution                          */
     /*   params   ... vector of parameter values                            */
     /*   n_params ... number of parameters                                  */
     /*----------------------------------------------------------------------*/
{
  switch (name[0]) {
  case 'b':
    if ( !strcmp( name, "binom") )
      return unur_distr_binomial (params,n_params);
    break;
  }

  /* unknown distribution */
  return NULL;
} /* _Runuran_get_std_discr() */
 
/*---------------------------------------------------------------------------*/
