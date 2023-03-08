/*****************************************************************************
 *                                                                           *
 *          UNU.RAN -- Universal Non-Uniform Random number generator         *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   FILE: performance.c                                                     *
 *                                                                           *
 *   PURPOSE:                                                                *
 *         Get information about performance of UNU.RAN generator objects    *
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

#include <unur_source.h>
#include <methods/unur_methods_source.h>
#include <distr/distr_source.h>

#include <methods/arou_struct.h>
#include <methods/ars_struct.h>
#include <methods/itdr_struct.h>
#include <methods/nrou_struct.h>
#include <methods/srou_struct.h>
#include <methods/tabl_struct.h>


#define DISTR     gen->distr->data.cont /* data for distribution in generator object */

/*---------------------------------------------------------------------------*/

#define CHECK_UNUR_PTR(s) do { \
    if (TYPEOF(s) != EXTPTRSXP || R_ExternalPtrTag(s) != _Runuran_tag()) \
      error("[UNU.RAN - error] invalid UNU.RAN object");		\
  } while (0)
/*---------------------------------------------------------------------------*/
/* Check pointer to R UNU.RAN generator object.                              */
/*---------------------------------------------------------------------------*/


/*****************************************************************************/
/* array for storing list elements                                           */

#define MAX_LIST  (10)       /* maximum number of list entries */

struct Rlist {
  int len;                   /* length of list (depends on method) */
  char *names[MAX_LIST];     /* names of list elements */
  SEXP values[MAX_LIST];     /* pointers to list elements */
};

/* functions for appending list elements */
void add_string(struct Rlist *list, char *key, const char *string);
void add_numeric(struct Rlist *list, char *key, double num);
void add_integer(struct Rlist *list, char *key, int inum);

/*---------------------------------------------------------------------------*/
/* add list elements                                                         */

void add_string(struct Rlist *list, char *key, const char *string)
{
  /* check length of list */
  if (list->len >= MAX_LIST)
    error("Runuran: Interval error! Please send bug report");

  /* store name of list entry */
  list->names[list->len] = key;

  /* create R object for list entry */
  PROTECT(list->values[list->len] = allocVector(STRSXP,1));
  SET_STRING_ELT(list->values[list->len], 0, mkChar(string));

  /* update length of list */
  ++list->len;
} /* end of add_string() */

void add_numeric(struct Rlist *list, char *key, double num)
{
  if (list->len >= MAX_LIST)
    error("Runuran: Interval error! Please send bug report");

  list->names[list->len] = key;
  PROTECT(list->values[list->len] = NEW_NUMERIC(1));
  REAL(list->values[list->len])[0] = num;
  ++list->len;
}

void add_integer(struct Rlist *list, char *key, int inum)
{
  if (list->len >= MAX_LIST)
    error("Runuran: Interval error! Please send bug report");

  list->names[list->len] = key;
  PROTECT(list->values[list->len] = NEW_INTEGER(1));
  INTEGER(list->values[list->len])[0] = inum;
  ++list->len;
}

/*****************************************************************************/

SEXP
Runuran_performance (SEXP sexp_unur)
     /*----------------------------------------------------------------------*/
     /* Get some informations about UNU.RAN generator object in an R list.   */
     /*                                                                      */
     /* Parameters:                                                          */
     /*   unur ... 'Runuran' object (S4 class)                               */ 
     /*                                                                      */
     /* Return:                                                              */
     /*   R list                                                             */
     /*----------------------------------------------------------------------*/
{

  SEXP sexp_gen;
  SEXP sexp_data;
  struct unur_gen *gen = NULL;

  int i;

  /* int n_list;                  /\* length of list (depends on method) *\/ */
  SEXP sexp_list;              /* pointer to R list */


  SEXP sexp_names;        /* FIXME */


  /* array of list elements */
  struct Rlist list;
  list.len = 0;

  /* slot 'data' should not be pesent */
  sexp_data = GET_SLOT(sexp_unur, install("data"));
  if (TYPEOF(sexp_data)!=NILSXP) {
    Rprintf("Object is PACKED !\n\n");
    return R_NilValue;
  }

  /* Extract pointer to UNU.RAN generator */
  sexp_gen = GET_SLOT(sexp_unur, install("unur"));
#ifdef RUNURAN_DEBUG
  CHECK_UNUR_PTR(sexp_gen);
#endif
  gen = R_ExternalPtrAddr(sexp_gen);
  if (gen == NULL) {
    errorcall_return(R_NilValue,"[UNU.RAN - error] broken UNU.RAN object");
  }



#define METHOD(string)       add_string(&list,"method",(string))

#define KIND_AR              add_string(&list,"type","rejection")
#define KIND_INV             add_string(&list,"type","inversion")
#define KIND_RINV            add_string(&list,"type","inversion+rejection")

#define REJECTIONCONST(num)  add_numeric(&list,"rejection.constant",(num))
#define AREA_HAT(num)        add_numeric(&list,"area.hat",(num))
#define AREA_SQUEEZE(num)    add_numeric(&list,"area.squeeze",(num))
#define NINTS(inum)          add_integer(&list,"intervals",(inum))



  /* get data */
  switch (gen->method) {

    /* discrete, univariate */
  case UNUR_METH_DARI:
    METHOD("DARI"); KIND_AR;
    /* REJECTIONCONST(); */
    break;
  case UNUR_METH_DAU:
    METHOD("DAU"); 
    break;
  case UNUR_METH_DGT:
    METHOD("DGT"); KIND_INV;
    break;
  case UNUR_METH_DSROU:
    METHOD("DSROU"); KIND_AR;
    /* REJECTIONCONST(); */
    break;
  case UNUR_METH_DSS:
    METHOD("DSS"); KIND_INV;
    break;
  case UNUR_METH_DSTD:
    METHOD("DSTD"); 
    break;

    /**************************/
    /* continuous, univariate */
    /**************************/

    /* ..................................................................... */
  case UNUR_METH_AROU:
#define GEN ((struct unur_arou_gen*)gen->datap)
    METHOD("AROU"); KIND_AR; 
    REJECTIONCONST ((gen->distr->set & UNUR_DISTR_SET_PDFAREA) 
		   ? 2.*GEN->Atotal/DISTR.area : NA_REAL);
    AREA_HAT (2.*GEN->Atotal);
    AREA_SQUEEZE (2.*GEN->Asqueeze);
    NINTS (GEN->n_segs);
#undef GEN
    break;
    /* ..................................................................... */
  case UNUR_METH_ARS:
#define GEN ((struct unur_ars_gen*)gen->datap)
    METHOD("ARS"); KIND_RINV; 
    REJECTIONCONST ((gen->distr->set & UNUR_DISTR_SET_PDFAREA) 
		   ? GEN->Atotal*exp(GEN->logAmax)/DISTR.area : NA_REAL);
    AREA_HAT (GEN->Atotal*exp(GEN->logAmax));
    NINTS (GEN->n_ivs);
#undef GEN
    break;
    /* ..................................................................... */
  case UNUR_METH_CSTD:
    METHOD("CSTD"); 
    break;
    /* ..................................................................... */
  case UNUR_METH_HINV:
    METHOD("HINV");  KIND_INV;
    break;
  case UNUR_METH_HRB:
    METHOD("HRB"); 
    break;
  case UNUR_METH_HRD:
    METHOD("HRD"); 
    break;
  case UNUR_METH_HRI:
    METHOD("HRI"); 
    break;
    /* ..................................................................... */
  case UNUR_METH_ITDR:
#define GEN ((struct unur_itdr_gen*)gen->datap)
    METHOD("ITDR"); KIND_AR; 
    REJECTIONCONST ((gen->distr->set & UNUR_DISTR_SET_PDFAREA) 
		    ? GEN->Atot/DISTR.area : NA_REAL);
    AREA_HAT (GEN->Atot);
#undef GEN
    break;
    /* ..................................................................... */
  case UNUR_METH_NINV:
    METHOD("NINV"); 
    break;
    /* ..................................................................... */
  case UNUR_METH_NROU:
#define GEN ((struct unur_nrou_gen*)gen->datap)
    METHOD("NROU"); KIND_AR;
    REJECTIONCONST ((gen->distr->set & UNUR_DISTR_SET_PDFAREA) 
		   ? 2.*(GEN->umax - GEN->umin)*GEN->vmax / DISTR.area : NA_REAL);
    AREA_HAT (2.*(GEN->umax - GEN->umin) * GEN->vmax);
#undef GEN
    break;
    /* ..................................................................... */
  case UNUR_METH_PINV:
    METHOD("PINV"); 
    break;
    /* ..................................................................... */
  case UNUR_METH_SROU:
#define GEN ((struct unur_srou_gen*)gen->datap)
#define SROU_VARFLAG_MIRROR   0x008u   /* use mirror principle */
    METHOD("SROU"); KIND_AR;
    if (!_unur_isone(GEN->r)) {
      REJECTIONCONST (NA_REAL);
      AREA_HAT (NA_REAL);
    }
    else {
      REJECTIONCONST((GEN->Fmode >= 0.) ? 2. : ((gen->variant & SROU_VARFLAG_MIRROR) ? 2.829 : 4.));
      AREA_HAT(2.*(GEN->vr - GEN->vl) * GEN->um);
    }
#undef SROU_VARFLAG_MIRROR
#undef GEN
    break;
    /* ..................................................................... */
  case UNUR_METH_SSR:
    METHOD("SSR"); KIND_AR;
    REJECTIONCONST (NA_REAL);
    AREA_HAT (NA_REAL);
    break;
    /* ..................................................................... */
  case UNUR_METH_TABL:
#define GEN ((struct unur_tabl_gen*)gen->datap)
#define TABL_VARIANT_IA   0x0001u   /* use immediate acceptance */
    METHOD("TABL"); 
    if (gen->variant&TABL_VARIANT_IA) {KIND_AR;} else {KIND_RINV;}
    REJECTIONCONST ((gen->distr->set & UNUR_DISTR_SET_PDFAREA) 
		   ? GEN->Atotal/DISTR.area : NA_REAL);
    AREA_HAT (GEN->Atotal);
    AREA_SQUEEZE (GEN->Asqueeze);
    NINTS (GEN->n_ivs);
#undef TABL_VARIANT_IA
#undef GEN
    break;
    /* ..................................................................... */
  case UNUR_METH_TDR:
    METHOD("TDR"); KIND_AR;
    /* REJECTIONCONST(); */

/* performance characteristics: */
/*    area(hat) = 1.00143 */
/*    rejection constant = 1.00143 */
/*    area ratio squeeze/hat = 0.994723 */
/*    # intervals = 51 */

    break;
    /* ..................................................................... */
  case UNUR_METH_UTDR:
    METHOD("UTDR"); KIND_AR;
    REJECTIONCONST (NA_REAL);
    AREA_HAT (NA_REAL);
    break;
    /* ..................................................................... */

    /* continuous, empirical */

  case UNUR_METH_EMPK:
    METHOD("EMPK"); 
    break;
  case UNUR_METH_EMPL:
    METHOD("EMPL"); 
    break;
  case UNUR_METH_HIST:
    METHOD("HIST"); 
    break;
  case UNUR_METH_VEMPK:
    METHOD("VEMPK"); 
    break;

    /* continuous, multivariate (random vector) */
  case UNUR_METH_GIBBS:
    METHOD("GIBBS"); 
    break;
  case UNUR_METH_HITRO:
    METHOD("HITRO"); 
    break;
  case UNUR_METH_MVSTD:
    METHOD("MVSTD"); 
    break;
  case UNUR_METH_MVTDR:
    METHOD("MVTDR"); 
    break;
  case UNUR_METH_VNROU:
    METHOD("VNROU"); 
    break;

    /* case UNUR_METH_NORTA: */
    /* case UNUR_METH_MCORR: */

    /* misc */
  case UNUR_METH_UNIF:
    METHOD("UNIF"); 
    break;

    /* case UNUR_METH_DEXT: */
    /* case UNUR_METH_CEXT: */

    /* automatic method --> meta method: selects one of the other methods automatically */
    /* case UNUR_METH_AUTO: */

  default: /* unknown ! */
    METHOD("NA"); 
  }


  /* a vector of the "names" attribute of the objects in our list */
  PROTECT(sexp_names = allocVector(STRSXP, list.len));
  for(i = 0; i < list.len; i++)
    SET_STRING_ELT(sexp_names, i,  mkChar(list.names[i]));

  /* create R list */
  PROTECT(sexp_list = allocVector(VECSXP, list.len)); 

  /* attach .... method string */
  for(i = 0; i < list.len; i++)
    SET_VECTOR_ELT(sexp_list, i, list.values[i]);
 
  /* attach vector names */
  setAttrib(sexp_list, R_NamesSymbol, sexp_names);


  UNPROTECT(list.len+2);
  //  UNPROTECT(3);
  return sexp_list;

} /* end of Runuran_performance() */

/*---------------------------------------------------------------------------*/
