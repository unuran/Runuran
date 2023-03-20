/*****************************************************************************
 *                                                                           *
 *          UNU.RAN -- Universal Non-Uniform Random number generator         *
 *                                                                           *
 *****************************************************************************
 *                                                                           *
 *   FILE: init.c                                                            *
 *                                                                           *
 *   PURPOSE:                                                                *
 *         Initialize package 'Runuran'                                      *
 *                                                                           *
 *****************************************************************************/

/*---------------------------------------------------------------------------*/

#include "Runuran.h"
#include "Runuran_ext.h"
#include <time.h>

/* internal header files for UNU.RAN */
#include <unur_source.h>

/*---------------------------------------------------------------------------*/

void 
R_init_Runuran (DllInfo *info  ATTRIBUTE__UNUSED) 
     /*----------------------------------------------------------------------*/
     /* Initialization routine when loading the DLL                          */
     /*                                                                      */
     /* Parameters:                                                          */
     /*   info ... passed by R and describes the DLL                         */
     /*                                                                      */
     /* Return:                                                              */
     /*   (void)                                                             */
     /*----------------------------------------------------------------------*/
{
  /* Set new UNU.RAN error handler */
  unur_set_error_handler( _Runuran_error_handler );

  /* Set R built-in generator as default URNG */
  unur_set_default_urng( unur_urng_new( _Runuran_R_unif_rand, NULL) );
  unur_set_default_urng_aux( unur_urng_new( _Runuran_R_unif_rand, NULL) );

  /* We use a built-in generator from the UNU.RAN library for the auxiliary URNG */
  {
    UNUR_URNG *aux;
    /* create URNG object */
    aux = unur_urng_new( unur_urng_MRG31k3p, NULL );
    unur_urng_set_reset( aux, unur_urng_MRG31k3p_reset );
    unur_urng_set_seed( aux, unur_urng_MRG31k3p_seed);
    /* seed URNG object */
    unur_urng_seed (aux, (long) time(NULL));
    /* set as auxiliary generator */
    unur_set_default_urng_aux( aux );
  }

  /* Register native routines */ 
  /* Not implemented yet */ 
  /*   R_registerRoutines(info, NULL, Runuran_CallEntries, NULL, NULL); */
  /*   R_useDynamicSymbols(info, FALSE); */

  /* Declare some C routines to be callable from other packages */ 
  R_RegisterCCallable("Runuran", "cont_init",   (DL_FUNC) &Runuran_ext_cont_init);
  R_RegisterCCallable("Runuran", "cont_params", (DL_FUNC) &unur_distr_cont_get_pdfparams);

} /* end of R_init_Runuran() */

/*---------------------------------------------------------------------------*/


void
R_unload_Runuran (DllInfo *info  ATTRIBUTE__UNUSED)
     /*----------------------------------------------------------------------*/
     /* Clear memory before unloading the DLL.                               */
     /*                                                                      */
     /* Parameters:                                                          */
     /*   info ... passed by R and describes the DLL                         */
     /*                                                                      */
     /* Return:                                                              */
     /*   (void)                                                             */
     /*----------------------------------------------------------------------*/
{
  unur_urng_free(unur_get_default_urng());
  unur_urng_free(unur_get_default_urng_aux());
} /* end of R_unload_Runuran() */

/*---------------------------------------------------------------------------*/

