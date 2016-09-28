/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_iSAsetname_H)
#define RCSID_iSAsetname_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetname.h,v 1.2301 2005/09/28 01:13:30 liyb Exp $"
#else
#if !defined(lint)
static char *iSAsetname_cvsid = "@(#) $Id: iSAsetname.h,v 1.2301 2005/09/28 01:13:30 liyb Exp $";
#endif
#endif
#endif
#endif

#ifndef _ISASETNAME_H
#define _ISASETNAME_H

  /* Usage Info */
  #define USAGE_FOR_SA "Usage: iSAsetname -sa -aid array_id -name array_name"
  #define USAGE_FOR_SP "Usage: iSAsetname -sp -aid array_id -port port_no -name port_name"
  #define USAGE_FOR_SL "Usage: iSAsetname -sl -aid array_id -ld ld_no -ldtype type -name ld_name"
  #define USAGE_FOR_SPOOL "Usage: iSAsetname -spool -aname array_name -oldname pool_oldname -newname pool_newname [-restart] [-nounlock] [-force] "
  #define USAGE_FOR_HELP "Usage: iSAsetname -?"

  /* Option */
  #define OPTION_SA "-sa"
  #define OPTION_SP "-sp"
  #define OPTION_SL "-sl"
  #define OPTION_SPOOL "-spool"
  #define OPTION_HELP "-?"

  #define PARAM_POOLNAME_OLD "-oldname"
  #define PARAM_POOLNAME_NEW "-newname"

  /* Output Info */
  #define ARRAY_NAME_LABEL "New Disk_Array Name"
  #define PORT_NAME_LABEL "New Port Name"
  #define LD_TYPE_LABEL "New LD Type"
  #define LD_NAME_LABEL "New LD Name"
  

  /* function prototype */
  int setName_sa(unsigned char, char*);
  int setName_sp(unsigned char, unsigned char, unsigned char, char * );
  int setName_sl(unsigned char, unsigned short, char * , char * );
  int setName_spool(char * , char * , char * , int , int , int );

#endif /* _ISASETNAME_H */
