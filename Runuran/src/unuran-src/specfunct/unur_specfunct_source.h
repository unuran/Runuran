/* Copyright (c) 2000-2023 Wolfgang Hoermann and Josef Leydold */
/* Department of Statistics and Mathematics, WU Wien, Austria  */

#ifndef UNUR_SPECFUNCT_SOURCE_H_SEEN
#define UNUR_SPECFUNCT_SOURCE_H_SEEN
#ifdef HAVE_LIBRMATH
#  ifdef R_UNURAN
#  else
#    define MATHLIB_STANDALONE
#  endif
#  include <Rmath.h>
#undef trunc
#define _unur_SF_incomplete_beta(x,a,b)   pbeta((x),(a),(b),TRUE,FALSE)
#define _unur_SF_ln_gamma(x)              lgammafn(x)
#define _unur_SF_ln_factorial(x)          lgammafn((x)+1.)
#define _unur_SF_incomplete_gamma(x,a)    pgamma(x,a,1.,TRUE,FALSE)
#define _unur_SF_bessel_k(x,nu)           bessel_k((x),(nu),1)
#define _unur_SF_cdf_normal(x)            pnorm((x),0.,1.,TRUE,FALSE)
#define _unur_SF_invcdf_normal(x)         qnorm((x),0.,1.,TRUE,FALSE)
#define _unur_SF_invcdf_beta(x,p,q)       qbeta((x),(p),(q),TRUE,FALSE)
#define _unur_SF_invcdf_gamma(x,shape,scale)  qgamma((x),(shape),(scale),TRUE,FALSE)
#else
double _unur_cephes_incbet(double a, double b, double x);
#define _unur_SF_incomplete_beta(x,a,b)   _unur_cephes_incbet((a),(b),(x))
double _unur_cephes_lgam(double x);
#define _unur_SF_ln_gamma(x)              _unur_cephes_lgam(x)
#define _unur_SF_ln_factorial(x)          _unur_cephes_lgam((x)+1.)
double _unur_cephes_igam(double a, double x);
#define _unur_SF_incomplete_gamma(x,a)    _unur_cephes_igam((a),(x))
double _unur_cephes_ndtr(double x);
#define _unur_SF_cdf_normal(x)            _unur_cephes_ndtr(x)
double _unur_cephes_ndtri(double x);
#define _unur_SF_invcdf_normal(x)         _unur_cephes_ndtri(x)
#endif
#if !HAVE_DECL_LOG1P
double _unur_log1p(double x);
#endif
#endif  
