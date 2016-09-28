/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_iSAsetld_H)
#define RCSID_iSAsetld_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetld.h,v 1.2303 2007/05/10 04:51:40 xingyh Exp $"
#else
#if !defined(lint)
static char *iSAsetld_cvsid = "@(#) $Id: iSAsetld.h,v 1.2303 2007/05/10 04:51:40 xingyh Exp $";
#endif
#endif
#endif
#endif

#ifndef _ISASETLD_H
#define _ISASETLD_H

  /* Usage Info */
  /* v5.1 add last two parameters xingyh*/
  #define USAGE_FOR_B "Usage: iSAsetld -b -aname array_name  -pname pool_name [-ldcount count] -ldsz ld_size {-ldn ld_no | -aid array_id [-sldno start_ld_no]} [-start start_addr] [-syscapa]  [-ldtype ld_type -name ld_name] [-bltime build_time] [-restart][-nounlock][-force][-qkfmt][-dnmcfmttm]"
 
  #define USAGE_FOR_R "Usage: iSAsetld -r -aname array_name {-ldn ld_no | -ldname ld_name } [-restart][-nounlock][-force]"

  #define USAGE_FOR_HELP "Usage: iSAsetld -?"

  /* Option */
  #define OPTION_B "-b"
  #define OPTION_R "-r"
  //#define OPTION_C "-c"  deleted by liyb 20050831
  #define OPTION_HELP "-?"

  
  /* Output Info */
  #define ISASETLD_B_LABEL "LogicalDisk Build request accept."
  #define ISASETLD_R_LABEL "LogicalDisk Release request accept."
  #define ISASETLD_C_LABEL "LogicalDisk Change(Owner) request accept."
  #define PD_GROUP_LABEL "Pd_group"
  #define ARRAY_NAME_LABEL "Array_Name"
  #define PD_GROUP_LABEL "Pd_group"
  #define RANK_LABEL "Rank"
  #define LD_COUNT_LABEL "Ld_count"
  #define LD_SIZE_LABEL "Ld_size"
  #define SYSCAPA_LABEL "Syscapa"
  #define ARRAY_ID_LABEL "Array_ID"
  #define START_LD_NO_LABEL "Start_Ld_no"
  #define START_ADDR_LABEL "Start_addr"
  #define OWNER_LABEL "Owner"
  #define BUILD_TIME_LABEL "Build_time"
  //#define LD_NO_LABEL  "Ld_no"
  #define LD_NAME_LABEL "Ld_name"
  #define LD_TYPE_LABEL "Ld_type"
  #define LD_BUILD_SIZE "Build_size"

  //added by liyb 20050831
  #define POOL_NAME_LABEL "POOL_Name"

  /* function prototype */
  int getldnarray(unsigned char array_id, unsigned int length, unsigned short * ldnArray, int start_id_no_set, unsigned short start_ld_no);

//replace "rank_no" with "pname",  delete pdg and own 
/* v5.1 change addr to long long and add four parameters support quick bind and larger ld size*/
  int setld_b(char * arr_name ,  char* pool_name,
        double ld_size, unsigned char array_id, unsigned short start_ld_no, unsigned long long start_addr, unsigned long start_addr_high,unsigned long start_addr_low,
        unsigned char syscapa, char * ld_type, char * ld_name, unsigned char build_time,
        int restart, int nounlock, int force, unsigned int length, unsigned short* ldn_array,
        int syscapa_set, int start_ld_no_set, int array_id_set, 
        int start_addr_set,  int build_time_set, int count_set, int quick_format, int dynmc_fmt_time);
  int setld_r(char *arr_name, unsigned short ld_no, char * ld_name, int restart, int nounlock, int force);

#endif /* _iSAsetld_H */
