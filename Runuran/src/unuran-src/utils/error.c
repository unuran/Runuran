/* Copyright (c) 2000-2024 Wolfgang Hoermann and Josef Leydold */
/* Department of Statistics and Mathematics, WU Wien, Austria  */

#include <unur_source.h>
#include <time.h>
#include <stdarg.h>
int unur_errno = UNUR_SUCCESS;
static UNUR_ERROR_HANDLER *_unur_error_handler = _unur_error_handler_default;
void 
_unur_error_x( const char *objid, const char *file, int line, 
	       const char *errortype, int errorcode, const char *reason )
{
  _unur_error_handler(objid, file, line, errortype, errorcode, reason);
  unur_errno = errorcode;
} 
void
_unur_error_handler_default( const char *objid, const char *file, int line, 
			     const char *errortype, int errorcode, const char *reason )
{
  FILE *LOG = unur_get_stream();
  if (!objid) objid = "UNURAN";
  fprintf(LOG,"%s: [%s] %s:%d - %s:\n", objid, errortype, file, line,
	  unur_get_strerror(errorcode));
  if (reason && strlen(reason))
    fprintf(LOG,"%s: ..>  %s\n", objid, reason);
  fflush(LOG);   
} 
void
_unur_error_handler_off( const char *objid ATTRIBUTE__UNUSED, 
			 const char *file ATTRIBUTE__UNUSED,
			 int line ATTRIBUTE__UNUSED, 
			 const char *errortype ATTRIBUTE__UNUSED,
			 int errorcode ATTRIBUTE__UNUSED,
			 const char *reason ATTRIBUTE__UNUSED )
{
  return;
} 
#ifdef UNUR_COOKIES
void
_unur_error_cookies( const char *file, int line, unsigned observed, unsigned expected )
{
  struct unur_string *reason = _unur_string_new();
  _unur_string_append( reason, "observed = %#x, expected = %#x", observed, expected );
  _unur_error_x( "COOKIE", file, line, "error", UNUR_ERR_COOKIE, reason->text);
  _unur_string_free( reason );
} 
#endif
const char *
unur_get_strerror ( const int errorcode )
{
  switch (errorcode) {
  case UNUR_SUCCESS:
    return "(no error)";
  case UNUR_ERR_DISTR_NPARAMS:
    return "(distribution) invalid number of parameters";
  case UNUR_ERR_DISTR_DOMAIN:
    return "(distribution) parameter out of domain";
  case UNUR_ERR_DISTR_GEN:
    return "(distribution) invalid variant for special generator";
  case UNUR_ERR_DISTR_INVALID:
    return "(distribution) invalid distribution object";
  case UNUR_ERR_DISTR_REQUIRED:
    return "(distribution) incomplete distribution object, entry missing";
  case UNUR_ERR_DISTR_UNKNOWN:
    return "(distribution) unknown distribution, cannot handle";
  case UNUR_ERR_DISTR_SET:
    return "(distribution) set failed (invalid parameter)";
  case UNUR_ERR_DISTR_GET:
    return "(distribution) get failed (parameter not set)";
  case UNUR_ERR_DISTR_DATA:
    return "(distribution) data are missing (cannot execute)";
  case UNUR_ERR_DISTR_PROP:
    return "(distribution) desired property does not exist";
  case UNUR_ERR_PAR_SET:
    return "(parameter) set failed, invalid parameter -> using default";
  case UNUR_ERR_PAR_VARIANT:
    return "(parameter) invalid variant -> using default";
  case UNUR_ERR_PAR_INVALID:
    return "(parameter) invalid parameter object";
  case UNUR_ERR_GEN_DATA:
    return "(generator) (possible) invalid data";
  case UNUR_ERR_GEN_CONDITION:
    return "(generator) condition for method violated";
  case UNUR_ERR_GEN_INVALID:
    return "(generator) invalid generator object";
  case UNUR_ERR_GEN_SAMPLING:
    return "(generator) sampling error";
  case UNUR_ERR_NO_REINIT:
    return "(generator) reinit not implemented";
  case UNUR_ERR_NO_QUANTILE:
    return "(generator) quantile not implemented";
  case UNUR_ERR_GEN:
    return "(generator)";
  case UNUR_ERR_URNG:
    return "(URNG)";
  case UNUR_ERR_URNG_MISS:
    return "(URNG) missing functionality";
  case UNUR_ERR_STR:
    return "(parser) invalid string";
  case UNUR_ERR_STR_UNKNOWN:
    return "(parser) unknown keyword";
  case UNUR_ERR_STR_SYNTAX:
    return "(parser) syntax error";
  case UNUR_ERR_STR_INVALID:
    return "(parser) invalid parameter";
  case UNUR_ERR_FSTR_SYNTAX:
    return "(function parser) syntax error";
  case UNUR_ERR_FSTR_DERIV:
    return "(function parser) cannot derivate function";
  case UNUR_ERR_DOMAIN:
    return "argument out of domain";
  case UNUR_ERR_ROUNDOFF:
    return "(serious) round-off error";
   case UNUR_ERR_MALLOC:
    return "virtual memory exhausted";
  case UNUR_ERR_NULL:
    return "invalid NULL pointer";
  case UNUR_ERR_COOKIE:
    return "invalid cookie";
  case UNUR_ERR_SILENT:
    return "(silent error)";
  case UNUR_ERR_GENERIC:
    return "";
  case UNUR_ERR_INF:
    return "invalid infinity occured";
  case UNUR_ERR_NAN:
    return "NaN occured";
  case UNUR_ERR_COMPILE:
    return "not available, recompile library";
  case UNUR_ERR_SHOULD_NOT_HAPPEN:
  default:
    return "error should not happen, report this!";
  }
} 
UNUR_ERROR_HANDLER *
unur_set_error_handler( UNUR_ERROR_HANDLER *new_handler )
{
  UNUR_ERROR_HANDLER *old_handler = _unur_error_handler;
  _unur_error_handler = (new_handler) ? new_handler : _unur_error_handler_default;
  return old_handler;
} 
UNUR_ERROR_HANDLER *
unur_set_error_handler_off( void )
{
  UNUR_ERROR_HANDLER *old_handler = _unur_error_handler;
  _unur_error_handler = _unur_error_handler_off;
  return old_handler;
} 
int
unur_get_errno ( void )
{
  return unur_errno;
} 
void
unur_reset_errno ( void )
{
  unur_errno = UNUR_SUCCESS;
}
