/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_iSAsetspare_H)
#define RCSID_iSAsetspare_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetspare.h,v 1.2300 2003/11/24 00:54:28 nsadmin Exp $"
#else
#if !defined(lint)
static char *iSAsetspare_cvsid = "@(#) $Id: iSAsetspare.h,v 1.2300 2003/11/24 00:54:28 nsadmin Exp $";
#endif
#endif
#endif
#endif

#ifndef _ISASETSPARE_H

#define _ISASETSPARE_H



  /* Usage Info */

  #define USAGE_FOR_B "Usage: iSAsetspare -b -aname array_name -pdg pd_group -pdn pd_no [-restart]"

  #define USAGE_FOR_R "Usage: iSAsetspare -r -aname array_name -pdg pd_group -pdn pd_no [-restart]"

  #define USAGE_FOR_HELP "Usage: iSAsetspare -?"



  /* Option */

  #define OPTION_B "-b"

  #define OPTION_R "-r"

  #define OPTION_HELP "-?"



//////////////////////////////////////////////////////////////////  

  /* Output Info */

  #define SPARE_BUILD_LABEL "Spare Build request accept."

  #define SPARE_RELEASE_LABEL "Spare Release request accept."

  #define ARRAY_NAME_LABEL "Array_Name"

  #define PD_GROUP_LABEL "Pd_group"

  #define PD_NO_LABEL "Pd_no"

  /* function prototype */

  int setspare_b(char *arr_name,unsigned char pd_g,unsigned char pd_n,int restart,int nounlock,int force );

  int setspare_r(char *arr_name,unsigned char pd_g,unsigned char pd_n,int restart,int nounlock,int force );



#endif /* _ISASETNAME_H */

