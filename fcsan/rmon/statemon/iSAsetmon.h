/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_iSAsetmon_H)
#define RCSID_iSAsetmon_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetmon.h,v 1.2300 2003/11/24 00:54:31 nsadmin Exp $"
#else
#if !defined(lint)
static char *iSAsetmon_cvsid = "@(#) $Id: iSAsetmon.h,v 1.2300 2003/11/24 00:54:31 nsadmin Exp $";
#endif
#endif
#endif
#endif

#ifndef _ISASETMON_H
#define _ISASETMON_H

  #define USAGE_FOR_ALL_OPTIONS "Usage: iSAsetmon {-start | -stop | -fstop} -aid array_id\nUsage: iSAsetname -?\n"
  #define OPTION_START "-start"
  #define OPTION_STOP "-stop"
  #define OPTION_FSTOP "-fstop"
  #define OPTION_HELP "-?"

  #define START_ACCEPT_INFO "Monitor start request accept."
  #define STOP_ACCEPT_INFO "Monitor stop request accept."
  #define FSTOP_ACCEPT_INFO "Monitor forced stop request accept."
  
  #define ARRAY_ID_LABEL "Array_ID"

#endif  /* _ISASETMON_H */
