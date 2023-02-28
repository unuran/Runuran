/*****************************************************************************
 *                                                                           *
 *          UNURAN -- Universal Non-Uniform Random number generator          *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   FILE: Runuran.h                                                         *
 *                                                                           *
 *   PURPOSE:                                                                *
 *         R interface for unuran                                            *
 *                                                                           *
 *****************************************************************************
     $Id: Runuran.h,v 1.1 2003/03/18 09:34:50 leydold Exp $
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

/*---------------------------------------------------------------------------*/

SEXP R_unur_init (SEXP sexp_string);
/*---------------------------------------------------------------------------*/
/* Create and initinalize unuran generator object.                           */
/*---------------------------------------------------------------------------*/

SEXP R_unur_sample (SEXP sexp_ptr, SEXP sexp_n);
/*---------------------------------------------------------------------------*/
/* Sample from unuran generator object.                                      */
/*---------------------------------------------------------------------------*/

void R_unur_free(SEXP sexp_ptr);
/*---------------------------------------------------------------------------*/
/* Free unuran generator object.                                             */
/*---------------------------------------------------------------------------*/

