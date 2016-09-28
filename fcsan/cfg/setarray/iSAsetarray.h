/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_iSAsetarray_H)
#define RCSID_iSAsetarray_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetarray.h,v 1.2301 2007/04/27 07:34:09 liuyq Exp $"
#else
#if !defined(lint)
static char *iSAsetarray_cvsid = "@(#) $Id: iSAsetarray.h,v 1.2301 2007/04/27 07:34:09 liuyq Exp $";
#endif
#endif
#endif
#endif

#ifndef _ISASETARRAY_H
#define _ISASETARRAY_H

  /* Usage Info */
  #define USAGE_FOR_CLD "Usage: iSAsetarray -cld -aname array_name -bltime build_time -ptype {all|basic|dynamic} [-restart] [-nounlock] [-force]"
  #define USAGE_FOR_CA "Usage: iSAsetarray -ca -aname array_name [-date array_date -time array_time] [-restart] [-nounlock] [-force]"
  #define USAGE_FOR_HELP "Usage: iSAsetarray -?"

  /* Option */
  #define OPTION_CLD "-cld"
  #define OPTION_CA "-ca"
  #define OPTION_HELP "-?"

  
  /* Output Info */
  #define ISASETARRAY_CLD_LABEL "DiskArray Change (LD:buildtime) request accept."
  #define ISASETARRAY_CA_LABEL "DiskArray Change(Array:time) request accept."
  #define ARRAY_NAME_LABEL "Array_Name"
  #define BUILD_TIME_LABEL "Build_time"
  #define TIME_LABEL "Time"
  #define DATE_LABEL "Date"
  /* function prototype */
  int setarray_cld(char *arr_name, unsigned char build_time, int restart, int nounlock, int force, char *ptype );
  int setarray_ca(char *arr_name, struct tm * tm_time, int restart, int nounlock, int force, unsigned char which);
  int check_date(int year, int month, int day);
#endif /* _iSAsetarray_H */
