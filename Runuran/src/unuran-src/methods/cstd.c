/* Copyright (c) 2000-2023 Wolfgang Hoermann and Josef Leydold */
/* Department of Statistics and Mathematics, WU Wien, Austria  */

#include <unur_source.h>
#include <distr/distr.h>
#include <distr/distr_source.h>
#include <distr/cont.h>
#include <distributions/unur_stddistr.h>
#include <urng/urng.h>
#include "unur_methods_source.h"
#include "x_gen_source.h"
#include "cstd.h"
#include "cstd_struct.h"
#define CSTD_DEBUG_REINIT    0x00000010u   
#define CSTD_DEBUG_CHG       0x00001000u   
#define CSTD_SET_VARIANT          0x01u
#define GENTYPE "CSTD"         
static struct unur_gen *_unur_cstd_init( struct unur_par *par );
static int _unur_cstd_reinit( struct unur_gen *gen );
static struct unur_gen *_unur_cstd_create( struct unur_par *par );
static int _unur_cstd_check_par( struct unur_gen *gen );
static struct unur_gen *_unur_cstd_clone( const struct unur_gen *gen );
static void _unur_cstd_free( struct unur_gen *gen);
#ifdef UNUR_ENABLE_LOGGING
static void _unur_cstd_debug_init( struct unur_gen *gen );
static void _unur_cstd_debug_chg_pdfparams( struct unur_gen *gen );
static void _unur_cstd_debug_chg_truncated( struct unur_gen *gen );
#endif
#define DISTR_IN  distr->data.cont      
#define PAR       ((struct unur_cstd_par*)par->datap) 
#define GEN       ((struct unur_cstd_gen*)gen->datap) 
#define DISTR     gen->distr->data.cont 
#define SAMPLE    gen->sample.cont      
#define CDF(x)    _unur_cont_CDF((x),(gen->distr))    
struct unur_par *
unur_cstd_new( const struct unur_distr *distr )
{ 
  struct unur_par *par;
  _unur_check_NULL(GENTYPE,distr,NULL);
  if (distr->type != UNUR_DISTR_CONT) {
    _unur_error(GENTYPE,UNUR_ERR_DISTR_INVALID,""); return NULL; }
  COOKIE_CHECK(distr,CK_DISTR_CONT,NULL);
  if (distr->id == UNUR_DISTR_GENERIC) {
    _unur_error(GENTYPE,UNUR_ERR_DISTR_INVALID,"standard distribution");
    return NULL;
  }
  if (DISTR_IN.init == NULL) {
    _unur_error(GENTYPE,UNUR_ERR_DISTR_REQUIRED,"init() for special generators");
    return NULL;
  }
  par = _unur_par_new( sizeof(struct unur_cstd_par) );
  COOKIE_SET(par,CK_CSTD_PAR);
  par->distr    = distr;            
  par->method   = UNUR_METH_CSTD;   
  par->variant  = 0u;               
  par->set      = 0u;               
  par->urng     = unur_get_default_urng(); 
  par->urng_aux = NULL;                    
  par->debug    = _unur_default_debugflag; 
  par->init = _unur_cstd_init;
  return par;
} 
int 
unur_cstd_set_variant( struct unur_par *par, unsigned variant )
{
  unsigned old_variant;
  _unur_check_NULL( GENTYPE, par, UNUR_ERR_NULL );
  _unur_check_NULL( GENTYPE, par->distr, UNUR_ERR_NULL );
  _unur_check_par_object( par, CSTD );
  old_variant = par->variant;
  par->variant = variant;
  if (par->DISTR_IN.init != NULL && par->DISTR_IN.init(par,NULL)==UNUR_SUCCESS ) {
    par->set |= CSTD_SET_VARIANT;    
    return UNUR_SUCCESS;
  }
  _unur_warning(GENTYPE,UNUR_ERR_PAR_VARIANT,"");
  par->variant = old_variant;
  return UNUR_ERR_PAR_VARIANT;
} 
int 
unur_cstd_chg_truncated( struct unur_gen *gen, double left, double right )
{
  double Umin, Umax;
  _unur_check_NULL( GENTYPE, gen, UNUR_ERR_NULL );
  _unur_check_gen_object( gen, CSTD, UNUR_ERR_GEN_INVALID );
  if ( ! GEN->is_inversion ) { 
    _unur_warning(gen->genid,UNUR_ERR_GEN_DATA,"truncated domain for non inversion method");
    return UNUR_ERR_GEN_DATA;
  }
  if (DISTR.cdf == NULL) {
    _unur_warning(gen->genid,UNUR_ERR_GEN_DATA,"truncated domain, CDF required");
    return UNUR_ERR_GEN_DATA;
  }
  if (left < DISTR.domain[0]) {
    _unur_warning(NULL,UNUR_ERR_DISTR_SET,"truncated domain too large");
    left = DISTR.domain[0];
  }
  if (right > DISTR.domain[1]) {
    _unur_warning(NULL,UNUR_ERR_DISTR_SET,"truncated domain too large");
    right = DISTR.domain[1];
  }
  if (left >= right) {
    _unur_warning(NULL,UNUR_ERR_DISTR_SET,"domain, left >= right");
    return UNUR_ERR_DISTR_SET;
  }
  Umin = (left > -INFINITY) ? CDF(left) : 0.;
  Umax = (right < INFINITY) ? CDF(right) : 1.;
  if (Umin > Umax) {
    _unur_error(gen->genid,UNUR_ERR_SHOULD_NOT_HAPPEN,"");
    return UNUR_ERR_SHOULD_NOT_HAPPEN;
  }
  if (_unur_FP_equal(Umin,Umax)) {
    _unur_warning(gen->genid,UNUR_ERR_DISTR_SET,"CDF values very close");
    if (_unur_iszero(Umin) || _unur_FP_same(Umax,1.)) {
      _unur_warning(gen->genid,UNUR_ERR_DISTR_SET,"CDF values at boundary points too close");
      return UNUR_ERR_DISTR_SET;
    }
  }
  DISTR.trunc[0] = left;
  DISTR.trunc[1] = right;
  GEN->umin = Umin;
  GEN->umax = Umax;
  gen->distr->set |= UNUR_DISTR_SET_TRUNCATED;
  gen->distr->set &= ~UNUR_DISTR_SET_STDDOMAIN;
#ifdef UNUR_ENABLE_LOGGING
  if (gen->debug & CSTD_DEBUG_CHG) 
    _unur_cstd_debug_chg_truncated( gen );
#endif
  return UNUR_SUCCESS;
} 
struct unur_gen *
_unur_cstd_init( struct unur_par *par )
{ 
  struct unur_gen *gen;
  CHECK_NULL(par,NULL);
  if (par->DISTR_IN.init == NULL) {
    _unur_error(GENTYPE,UNUR_ERR_NULL,"");
    return NULL;
  }
  if ( par->method != UNUR_METH_CSTD ) {
    _unur_error(GENTYPE,UNUR_ERR_PAR_INVALID,"");
    return NULL;
  }
  COOKIE_CHECK(par,CK_CSTD_PAR,NULL);
  gen = _unur_cstd_create(par);
  _unur_par_free(par);
  if (!gen) return NULL;
  GEN->is_inversion = FALSE;   
  if ( DISTR.init(NULL,gen)!=UNUR_SUCCESS ) {
    _unur_error(GENTYPE,UNUR_ERR_GEN_DATA,"variant for special generator");
    _unur_cstd_free(gen); return NULL; 
  }
  if (_unur_cstd_check_par(gen) != UNUR_SUCCESS) {
    _unur_cstd_free(gen); return NULL;
  }
#ifdef UNUR_ENABLE_LOGGING
  if (gen->debug) _unur_cstd_debug_init(gen);
#endif
  return gen;
} 
int
_unur_cstd_reinit( struct unur_gen *gen )
{
  int rcode;
  GEN->is_inversion = FALSE;   
  if ( DISTR.init(NULL,gen)!=UNUR_SUCCESS ) {
    _unur_error(gen->genid,UNUR_ERR_GEN_DATA,"parameters");
    return UNUR_ERR_GEN_DATA;
  }
  if ( (rcode = _unur_cstd_check_par(gen)) != UNUR_SUCCESS)
    return rcode;
#ifdef UNUR_ENABLE_LOGGING
    if (gen->debug & CSTD_DEBUG_REINIT) 
      _unur_cstd_debug_chg_pdfparams( gen );
#endif
  return UNUR_SUCCESS;
} 
struct unur_gen *
_unur_cstd_create( struct unur_par *par )
{
  struct unur_gen *gen;
  CHECK_NULL(par,NULL);  COOKIE_CHECK(par,CK_CSTD_PAR,NULL);
  gen = _unur_generic_create( par, sizeof(struct unur_cstd_gen) );
  COOKIE_SET(gen,CK_CSTD_GEN);
  gen->genid = _unur_set_genid(GENTYPE);
  SAMPLE = NULL;      
  gen->destroy = _unur_cstd_free;
  gen->clone = _unur_cstd_clone;
  gen->reinit = _unur_cstd_reinit;
  GEN->gen_param = NULL;        
  GEN->n_gen_param = 0;         
  GEN->is_inversion = FALSE;    
  GEN->sample_routine_name = NULL ;  
  GEN->umin        = 0;    
  GEN->umax        = 1;    
  return gen;
} 
int
_unur_cstd_check_par( struct unur_gen *gen )
{
  if (!(gen->distr->set & UNUR_DISTR_SET_STDDOMAIN)) {
    gen->distr->set &= UNUR_DISTR_SET_TRUNCATED;
    DISTR.trunc[0] = DISTR.domain[0];
    DISTR.trunc[1] = DISTR.domain[1];
    if ( ! GEN->is_inversion ) {
      _unur_error(gen->genid,UNUR_ERR_GEN_DATA,"domain changed for non inversion method");
      return UNUR_ERR_GEN_DATA;
    }
    if (DISTR.cdf == NULL) {
      _unur_error(gen->genid,UNUR_ERR_GEN_DATA,"domain changed, CDF required");
      return UNUR_ERR_GEN_DATA;
    }
    GEN->umin = (DISTR.trunc[0] > -INFINITY) ? CDF(DISTR.trunc[0]) : 0.;
    GEN->umax = (DISTR.trunc[1] < INFINITY)  ? CDF(DISTR.trunc[1]) : 1.;
  }
  return UNUR_SUCCESS;
} 
struct unur_gen *
_unur_cstd_clone( const struct unur_gen *gen )
{ 
#define CLONE  ((struct unur_cstd_gen*)clone->datap)
  struct unur_gen *clone;
  CHECK_NULL(gen,NULL);  COOKIE_CHECK(gen,CK_CSTD_GEN,NULL);
  clone = _unur_generic_clone( gen, GENTYPE );
  if (GEN->gen_param) {
    CLONE->gen_param = _unur_xmalloc( GEN->n_gen_param * sizeof(double) );
    memcpy( CLONE->gen_param, GEN->gen_param, GEN->n_gen_param * sizeof(double) );
  }
  return clone;
#undef CLONE
} 
void
_unur_cstd_free( struct unur_gen *gen )
{ 
  if( !gen ) 
    return;
  COOKIE_CHECK(gen,CK_CSTD_GEN,RETURN_VOID);
  if ( gen->method != UNUR_METH_CSTD ) {
    _unur_warning(gen->genid,UNUR_ERR_GEN_INVALID,"");
    return;
  }
  SAMPLE = NULL;   
  if (GEN->gen_param)  free(GEN->gen_param);
  _unur_generic_free(gen);
} 
#ifdef UNUR_ENABLE_LOGGING
void
_unur_cstd_debug_init( struct unur_gen *gen )
{
  FILE *log;
  CHECK_NULL(gen,RETURN_VOID);  COOKIE_CHECK(gen,CK_CSTD_GEN,RETURN_VOID);
  log = unur_get_stream();
  fprintf(log,"%s:\n",gen->genid);
  fprintf(log,"%s: type    = continuous univariate random variates\n",gen->genid);
  fprintf(log,"%s: method  = generator for standard distribution\n",gen->genid);
  fprintf(log,"%s:\n",gen->genid);
  _unur_distr_cont_debug( gen->distr, gen->genid );
  fprintf(log,"%s: sampling routine = ",gen->genid);
  if (GEN->sample_routine_name)
    fprintf(log,"%s()",GEN->sample_routine_name);
  else
    fprintf(log,"(Unknown)");
  if (GEN->is_inversion)
    fprintf(log,"   (Inversion)");
  fprintf(log,"\n%s:\n",gen->genid);
  if (!(gen->distr->set & UNUR_DISTR_SET_STDDOMAIN)) {
    fprintf(log,"%s: domain has been changed. U in (%g,%g)\n",gen->genid,GEN->umin,GEN->umax);
    fprintf(log,"%s:\n",gen->genid);
  }
} 
void 
_unur_cstd_debug_chg_pdfparams( struct unur_gen *gen )
{
  FILE *log;
  int i;
  CHECK_NULL(gen,RETURN_VOID);  COOKIE_CHECK(gen,CK_CSTD_GEN,RETURN_VOID);
  log = unur_get_stream();
  fprintf(log,"%s: parameters of distribution changed:\n",gen->genid);
  for( i=0; i<DISTR.n_params; i++ )
      fprintf(log,"%s:\tparam[%d] = %g\n",gen->genid,i,DISTR.params[i]);
  if (gen->distr->set & UNUR_DISTR_SET_TRUNCATED)
    fprintf(log,"%s:\tU in (%g,%g)\n",gen->genid,GEN->umin,GEN->umax);
} 
void 
_unur_cstd_debug_chg_truncated( struct unur_gen *gen )
{
  FILE *log;
  CHECK_NULL(gen,RETURN_VOID);  COOKIE_CHECK(gen,CK_CSTD_GEN,RETURN_VOID);
  log = unur_get_stream();
  fprintf(log,"%s: domain of truncated distribution changed:\n",gen->genid);
  fprintf(log,"%s:\tdomain = (%g, %g)\n",gen->genid, DISTR.trunc[0], DISTR.trunc[1]);
  fprintf(log,"%s:\tU in (%g,%g)\n",gen->genid,GEN->umin,GEN->umax);
} 
#endif   