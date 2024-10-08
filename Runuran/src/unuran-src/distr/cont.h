/* Copyright (c) 2000-2024 Wolfgang Hoermann and Josef Leydold */
/* Department of Statistics and Mathematics, WU Wien, Austria  */

UNUR_DISTR *unur_distr_cont_new( void );
int unur_distr_cont_set_pdf( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *pdf );
int unur_distr_cont_set_dpdf( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *dpdf );
int unur_distr_cont_set_cdf( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *cdf );
int unur_distr_cont_set_invcdf( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *invcdf );
UNUR_FUNCT_CONT *unur_distr_cont_get_pdf( const UNUR_DISTR *distribution );
UNUR_FUNCT_CONT *unur_distr_cont_get_dpdf( const UNUR_DISTR *distribution );
UNUR_FUNCT_CONT *unur_distr_cont_get_cdf( const UNUR_DISTR *distribution );
UNUR_FUNCT_CONT *unur_distr_cont_get_invcdf( const UNUR_DISTR *distribution );
double unur_distr_cont_eval_pdf( double x, const UNUR_DISTR *distribution );
double unur_distr_cont_eval_dpdf( double x, const UNUR_DISTR *distribution );
double unur_distr_cont_eval_cdf( double x, const UNUR_DISTR *distribution );
double unur_distr_cont_eval_invcdf( double u, const UNUR_DISTR *distribution );
int unur_distr_cont_set_logpdf( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *logpdf );
int unur_distr_cont_set_dlogpdf( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *dlogpdf );
int unur_distr_cont_set_logcdf( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *logcdf );
UNUR_FUNCT_CONT *unur_distr_cont_get_logpdf( const UNUR_DISTR *distribution );
UNUR_FUNCT_CONT *unur_distr_cont_get_dlogpdf( const UNUR_DISTR *distribution );
UNUR_FUNCT_CONT *unur_distr_cont_get_logcdf( const UNUR_DISTR *distribution );
double unur_distr_cont_eval_logpdf( double x, const UNUR_DISTR *distribution );
double unur_distr_cont_eval_dlogpdf( double x, const UNUR_DISTR *distribution );
double unur_distr_cont_eval_logcdf( double x, const UNUR_DISTR *distribution );
int unur_distr_cont_set_pdfstr( UNUR_DISTR *distribution, const char *pdfstr );
int unur_distr_cont_set_cdfstr( UNUR_DISTR *distribution, const char *cdfstr );
char *unur_distr_cont_get_pdfstr( const UNUR_DISTR *distribution );
char *unur_distr_cont_get_dpdfstr( const UNUR_DISTR *distribution );
char *unur_distr_cont_get_cdfstr( const UNUR_DISTR *distribution );
int unur_distr_cont_set_pdfparams( UNUR_DISTR *distribution, const double *params, int n_params );
int unur_distr_cont_get_pdfparams( const UNUR_DISTR *distribution, const double **params );
int unur_distr_cont_set_pdfparams_vec( UNUR_DISTR *distribution, int par, const double *param_vec, int n_param_vec );
int unur_distr_cont_get_pdfparams_vec( const UNUR_DISTR *distribution, int par, const double **param_vecs );
int unur_distr_cont_set_logpdfstr( UNUR_DISTR *distribution, const char *logpdfstr );
char *unur_distr_cont_get_logpdfstr( const UNUR_DISTR *distribution );
char *unur_distr_cont_get_dlogpdfstr( const UNUR_DISTR *distribution );
int unur_distr_cont_set_logcdfstr( UNUR_DISTR *distribution, const char *logcdfstr );
char *unur_distr_cont_get_logcdfstr( const UNUR_DISTR *distribution );
int unur_distr_cont_set_domain( UNUR_DISTR *distribution, double left, double right );
int unur_distr_cont_get_domain( const UNUR_DISTR *distribution, double *left, double *right );
int unur_distr_cont_get_truncated( const UNUR_DISTR *distribution, double *left, double *right );
int unur_distr_cont_set_hr( UNUR_DISTR *distribution, UNUR_FUNCT_CONT *hazard );
UNUR_FUNCT_CONT *unur_distr_cont_get_hr( const UNUR_DISTR *distribution );
double unur_distr_cont_eval_hr( double x, const UNUR_DISTR *distribution );
int unur_distr_cont_set_hrstr( UNUR_DISTR *distribution, const char *hrstr );
char *unur_distr_cont_get_hrstr( const UNUR_DISTR *distribution );
int unur_distr_cont_set_mode( UNUR_DISTR *distribution, double mode );
int unur_distr_cont_upd_mode( UNUR_DISTR *distribution );
double unur_distr_cont_get_mode( UNUR_DISTR *distribution );
int unur_distr_cont_set_center( UNUR_DISTR *distribution, double center );
double unur_distr_cont_get_center( const UNUR_DISTR *distribution );
int unur_distr_cont_set_pdfarea( UNUR_DISTR *distribution, double area );
int unur_distr_cont_upd_pdfarea( UNUR_DISTR *distribution );
double unur_distr_cont_get_pdfarea( UNUR_DISTR *distribution );
