/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_iSAsetpool_H)
#define RCSID_iSAsetpool_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetpool.h,v 1.4 2007/04/27 07:32:06 liuyq Exp $"
#else
#if !defined(lint)
static char *iSAsetrbpool_cvsid = "@(#) $Id: iSAsetpool.h,v 1.4 2007/04/27 07:32:06 liuyq Exp $";
#endif
#endif
#endif
#endif

#ifndef  _ISASETPOOL_H
#define _ISASETPOOL_H

    /* boundary value */
    #define MAX_PD_CNT  60   //15  changed by liyb 20050831
    
    /* options */
    #define OPTION_B "-b"
    #define OPTION_R "-r"
    #define OPTION_E "-e"
    #define OPTION_C "-c"
    #define OPTION_SB "-sb"
    #define OPTION_SE "-se"
    #define OPTION_HELP "-?"

    /* option id */
    #define OPTION_ID_B 0
    #define OPTION_ID_R 1
    #define OPTION_ID_E 2
    #define OPTION_ID_C 3
    #define OPTION_ID_SB 4
    #define OPTION_ID_SE 5

    /* usages */
    #define USAGE_B  "Usage:iSAsetpool -b -aname array_name -pdg pd_group -pdn pd_no[,pd_no[...]] -pno pool_no -pname  pool_name    -raid raid_type -basepd -|6|10   [-rbtime rebuild_time] [-restart][-nounlock][-force]"
    #define USAGE_SB  "Usage:iSAsetpool -sb -aname array_name -pdg pd_group -pdn pd_no[,pd_no[...]] -pno pool_no -pname  pool_name    -raid raid_type -basepd -|6|10   [-rbtime rebuild_time] [-restart][-nounlock][-force]"
    #define USAGE_R  "Usage:iSAsetpool -r -aname array_name  -pname pool_name  [-restart][-nounlock][-force]"
    #define USAGE_E  "Usage:iSAsetpool -e -aname array_name -pdg pd_group -pname pool_name  -pdn pd_no[,pd_no[,pd_no...] ]  -emode off|on  [-exptime 0-255][-restart][-nounlock][-force]"
    #define USAGE_SE  "Usage:iSAsetpool -se -aname array_name -pdg pd_group -pname pool_name  -pdn pd_no[,pd_no[,pd_no...] ]  -emode off|on  [-exptime 0-255][-restart][-nounlock][-force]"
    #define USAGE_C  "Usage:iSAsetpool -c -aname array_name -pdg pd_group -pname pool_name  -rbtime 0-255 [-restart][-nounlock][-force]"
    #define USAGE_HELP "Usage:iSAsetpool -?"


    /* labels */
    #define LABEL_ARRAY_NAME "Array_Name"
    #define LABEL_PD_GROUP "Pd_group"
    #define LABEL_PD_NO "Pd_no"
 //delete LABEL_RANK "Rank"  by liyb 20050831
    #define LABEL_POOL_NO "POOL_No"      //added by liyb 20050831
    #define LABEL_POOL_NAME "POOL_Name"      //added by liyb 20050831
    #define LABEL_EXPAND_MODE_FLAG "Expand_mode"  //add by liyb 20050831
    #define LABEL_RAID "RAID"
    #define LABEL_BASE_PD "Base_pd"      //added by liyb 20050831
    #define LABEL_REBUILD_TIME "Rebuild_time"
    #define LABEL_EXPAND_TIME "Expand_time"
    #define LABEL_CAPACITY  "Capacity"
    
    /* Output Info  */
   // "rank "  in  the following 2 infos is  changed into  "pool"     liyb 20020831 
    #define INFO_ACCEPT_BUILD_REQUEST "POOL Build request accept."
    #define INFO_ACCEPT_RELEASE_REQUEST "POOL Release request accept."
    #define INFO_ACCEPT_EXPAND_REQUEST "POOL Expand request accept."
    #define INFO_ACCEPT_CHANGE_R_REQUEST "POOL Change(rbtime) request accept."
    #define INFO_ACCEPT_CHANGE_M_REQUEST "POOL Change(rbtime(m)) request accept."
    #define NO_BASE_PD "-"   //added by liyb 200508231

#endif

