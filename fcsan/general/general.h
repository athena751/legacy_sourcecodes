/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_general_H)
#define RCSID_general_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: general.h,v 1.2307 2007/05/10 04:54:13 xingyh Exp $"
#else
#if !defined(lint)
static char *general_cvsid = "@(#) $Id: general.h,v 1.2307 2007/05/10 04:54:13 xingyh Exp $";
#endif
#endif
#endif
#endif

#ifndef _GENERAL_H
#define _GENERAL_H

#ifndef ISMSM_CLI_INIT_ZERO
#define ISMSM_CLI_INIT_ZERO(_param){  \
    memset(&(_param), 0, sizeof(_param));  \
}
#endif

/*for memory leak detect*/

#include "iSMSMApi.h"
#include "iSMSMerr.h"
#include "iSMSMApi_cfg.h" /*remarked by hujing for SI04B*/
#include <stdio.h>
#include <stdlib.h>

#ifdef DMALLOC
#include "dmalloc.h"
#endif

  /* command name */
#define CMDNAME_ISASETNAME "iSAsetname"
#define CMDNAME_ISASETMON "iSAsetmon"
#define CMDNAME_ISADISKLIST "iSAdisklist"
#define CMDNAME_ISAREFRESHLIST "iSArefreshlist"
#define CMDNAME_ISASETLKENV "iSAlksetenv" 
#define CMDNAME_ISASETSPARE "iSAsetspare"


#define CMDNAME_ISASETLD "iSAsetld"
#define CMDNAME_ISASETARRAY "iSAsetarray"
#define CMDNAME_ISASETPOOL "iSAsetpool"    //added by liyb  20050831

  /* Parameter */
#define MIN_PARAM_NUM  10
#define MAX_PARAM_NUM  28

#define PARAM_AID "-aid"
#define PARAM_NAME "-name"
#define PARAM_PORT "-port"
#define PARAM_LD "-ld"
#define PARAM_LDTYPE "-ldtype"
#define PARAM_LCOUNT "-lcount"
#define PARAM_LDCOUNT "-ldcount"
#define PARAM_LDSET  "-ldset"
#define PARAM_POOL  "-pool"
#define PARAM_NLD  "-nld"
#define PARAM_NPD  "-npd"
#define PARAM_ANAME "-aname"
#define PARAM_PTYPE "-ptype"
#define PARAM_ALL "all"
#define PARAM_BASIC "basic"
#define PARAM_DYNAMIC "dynamic"
#define PARAM_PDG   "-pdg"
#define PARAM_PDN "-pdn"
#define PARAM_RAID "-raid"
#define PARAM_RBTIME "-rbtime"
#define PARAM_MRBTIME "-mrbtime"
#define PARAM_LDSZ "-ldsz"
#define PARAM_LDNO "-ldno"
#define PARAM_LDN "-ldn"
#define PARAM_LDNAME "-ldname"
#define PARAM_SLDNO "-sldno"
#define PARAM_START "-start"
#define PARAM_SYSCAPA "-syscapa"
#define PARAM_OWNER "-owner"
#define PARAM_BLTIME "-bltime"
#define PARAM_DATE "-date"
#define PARAM_TIME "-time"
#define PARAM_RESTART "-restart"
#define PARAM_NOUNLOCK "-nounlock"
#define PARAM_FORCE "-force"
#define PARAM_EXPTIME "-exptime"
#define PARAM_RANGE "-range"
#define PARAM_LUN "-lun"
#define PARAM_LDALL "-ldall"
#define PARAM_PATH "-path"
#define PARAM_NPATH "-npath"
#define PARAM_DETAIL "-detail"
#define PARAM_ACC_START "start"
#define PARAM_STOP "stop"
#define PARAM_WWN "wwn"
#define PARAM_CHG_PORT "port"
#define PARAM_PNAME "-pname"
#define PARAM_PNO "-pno"
#define PARAM_PALL "-pall"
#define PARAM_OID "-oid"
#define PARAM_ONAME "-oname" 
#define PARAM_PF "-pf"
#define PARAM_POOLNAME  "-pname" //added by liyb 20050905
#define PARAM_POOLNO  "-pno"//added by liyb 20050905
#define PARAM_EXPANDMODE  "-emode"//added by liyb 20050905

#define PARAM_BASE_PD "-basepd"  //added by liyb 20050831

/* v5.1 add quick bind  xingyh 200704*/
#define PARAM_QUICK_FORMAT        "-qkfmt"
#define PARAM_DYNMC_FORMAT_TIME   "-dnmcfmttm"

  /*Output Label Info*/
#define ARRAY_ID_LABEL "Array_ID"  
#define PORT_NO_LABEL "Port_No"
#define LD_NO_LABEL "LD_No"
#define CONDITION_CODE_LABEL "01000:Condition Code"
#define CONDITION_CODE_STOPPED "ffffffffffffffff"
#define CONDITION_CODE_ZERO "0000000000000000"

  /* Watch State */
#define WATCH_STATE_MONITOR_OFF 0x10
#define WATCH_STATE_MONITOR_OFF_ERROR 0x11
#define WATCH_STATE_MONITOR_OFF_SEIZE 0x12


  /*Command Success Info*/    
#define COMMAND_SUCCESS_INFO "Command successful."

  /* Error Info */
#define COMMAND_PROCESS_ERR_INFO "command error occurred."
#define PARAM_ERR_INFO "Invalid command option"
#define ERROR_CODE_LABEL "error_code"
#define COMMAND_CODE_LABEL "command_code"
#define INVALID_ARRAY_ID "Invalid array ID" 
#define INVALID_PORT_NO "Invalid port_no"
#define INVALID_LD_NO "Invalid ld_no"
#define INVALID_ARRAY_NAME "Invalid array name"
#define INVALID_PORT_NAME "Invalid port name"
#define INVALID_LD_NAME "Invalid LD name"
#define INVALID_LD_TYPE "Invalid LD type"
#define INVALID_LCOUNT "Invalid lcount"
#define INVALID_LDSET_ID "Invalid ldset ID"
 
  /* Length of name */
#define ARRAY_NAME_MAX_LENGTH 32
#define PORT_NAME_MAX_LENGTH 32
#define LD_NAME_MAX_LENGTH 24
#define LDSET_NAME_MAX_LENGTH 16
#define LD_TYPE_MAX_LENGTH 8
#define LDSET_TYPE_MAX_LENGTH 2
//added by liyb 20050831
#define  POOL_NAME_MAX_LENGTH 32

/* add by xingyh */
#define MAX_LD_SIZE          262144.0
#define MIN_LD_SIZE          1.0
#define MAX_BUILD_TIME       255
#define FOUR_BYTE            32
#define HEX                  16
#define BIT_MASK             0xffffffff

  /* function code */
#define CMDCODE_FUNC_ISADISKLIST_D 1
#define CMDCODE_FUNC_ISADISKLIST_DS 2  
#define CMDCODE_FUNC_ISADISKLIST_DAP 3
#define CMDCODE_FUNC_ISADISKLIST_DAL 4
#define CMDCODE_FUNC_ISADISKLIST_DP 5
#define CMDCODE_FUNC_ISADISKLIST_DD 6
#define CMDCODE_FUNC_ISADISKLIST_L_NOOPTION 7
#define CMDCODE_FUNC_ISADISKLIST_L_LDSET 8
#define CMDCODE_FUNC_ISADISKLIST_L_PORT 9
#define CMDCODE_FUNC_ISADISKLIST_L_POOL 10
#define CMDCODE_FUNC_ISADISKLIST_LP 11
#define CMDCODE_FUNC_ISADISKLIST_LS 12
#define CMDCODE_FUNC_ISADISKLIST_LAP 13
#define CMDCODE_FUNC_ISADISKLIST_LAL 14
#define CMDCODE_FUNC_ISADISKLIST_P 15
#define CMDCODE_FUNC_ISADISKLIST_PL 16
#define CMDCODE_FUNC_ISADISKLIST_PD 17
#define CMDCODE_FUNC_ISADISKLIST_C 18
#define CMDCODE_FUNC_ISADISKLIST_E 19

#define CMDCODE_FUNC_ISADISKLIST_O  25
#define CMDCODE_FUNC_ISADISKLIST_OL 26
#define CMDCODE_FUNC_ISADISKLIST_OS 27

#define CMDCODE_FUNC_ISADISKLIST_POOL 20      /*  repladed by liyb 20050829*/
#define CMDCODE_FUNC_ISADISKLIST_POOLP 22    /*  repladed by liyb 20050829*/
#define CMDCODE_FUNC_ISADISKLIST_POOLL 23    /*  repladed by liyb 20050829*/
#define CMDCODE_FUNC_ISADISKLIST_LPOOL 24   /*  repladed by liyb 20050829*/

#define CMDCODE_FUNC_ISADISKLIST_PF 28



#define CMDCODE_FUNC_ISAREFRESHLIST 30
#define CMDCODE_FUNC_SETNAME_SA 41
#define CMDCODE_FUNC_SETNAME_SP 42
#define CMDCODE_FUNC_SETNAME_SL 43
#define CMDCODE_FUNC_SETNAME_SPOOL 44
#define CMDCODE_FUNC_SETMON 50
#define CMDCODE_FUNC_SETLKENV_L 63
#define CMDCODE_FUNC_SETLKENV_UL 64
#define CMDCODE_FUNC_SETSPARE_B 65
#define CMDCODE_FUNC_SETSPARE_R 66 
#define CMDCODE_FUNC_SETARRAY_CLD 67
#define CMDCODE_FUNC_SETARRAY_CA 68
#define CMDCODE_FUNC_SETARRAY_MAIN 69


#define CMDCODE_FUNC_SETLD_B 70
#define CMDCODE_FUNC_SETLD_R 71


#define CMDCODE_FUNC_SETLD_GETLDNARRAY 73
#define CMDCODE_FUNC_SETLD_MAIN 74


#define CMDCODE_FUNC_ISASETPOOL_B 75///replaced by liyb 20050831
#define CMDCODE_FUNC_ISASETPOOL_R 76///replaced by liyb 20050831
#define CMDCODE_FUNC_ISASETPOOL_E 77///replaced by liyb 20050831
#define CMDCODE_FUNC_ISASETPOOL_C 78///replaced by liyb 20050831




#define CMDCODE_FUNC_ISASETLDSET_B  80
#define CMDCODE_FUNC_ISASETLDSET_D  81
#define CMDCODE_FUNC_ISASETLDSET_LS  82
#define CMDCODE_FUNC_ISASETLDSET_LR  83

#define CMDCODE_FUNC_ISASETLDSET_PS  84
#define CMDCODE_FUNC_ISASETLDSET_PE  85
#define CMDCODE_FUNC_ISASETLDSET_PR  86
#define CMDCODE_FUNC_SETACCTL_A 87
#define CMDCODE_FUNC_SETACCTL_M 88
#define CMDCODE_FUNC_SETPORT_SP 89


#define CMDCODE_FUNC_ISASETPOOL_SB 90///added by liyb 20051221
#define CMDCODE_FUNC_ISASETPOOL_SE 91///added by liyb 20051221


  /* error type */
#define CMDCODE_TYPE_SYSTEMFUNC 1
#define CMDCODE_TYPE_INTERNAL 2
#define CMDCODE_TYPE_API 3
#define CMDCODE_TYPE_WRONGLD_RAID6 9

  /* message number */
#define MSGNO_ERROR_OCCURRED 101
#define MSGNO_PARAM_ERROR 102
#define MSGNO_FCSAN_PREFIX 1

  /* return value */
#define FCSAN_SUCCESS_CODE 0 /* This constant cannot be changed under any circumstances */
#define FCSAN_ERROR_CODE 1  /* This constant can be changed to any non-zero number */  

/*iSM server Version ID*/
#define SERVER_VERSION_15  0x02
#define MAXLDN 65535 



  /* function prototype */
extern int convert_arrayid(char * , unsigned char * );
extern int convert_ldno(char * , unsigned short * );
extern int convert_lun(char *  , int * ); 
extern int convert_ldset_no(char * , unsigned short * );
//extern int convert_port_rank_no(char * ,unsigned char *,unsigned char *);  //deleted by liyb 20050905
extern int convert_lcount(char* , unsigned int*);    
extern int chars2str(char * , int , char * );
extern void print_condition_code(iSMSMoutDataInfo);
extern int isInvalidName(char * , unsigned int);
extern int isInvalidTypeName(char *  , unsigned int , unsigned int );
extern int isInvalidLdType(char *);
extern int hex_char_unchar(char * source, unsigned char * destine) ;
extern int hex_char_unshort(char * source, unsigned short * destine);     
extern int address_char_unlong(char * source, unsigned long * destine);
int compute_size_block(double ld_size,int is_syscapa,unsigned long long * dest_full,unsigned long * dest_high, unsigned long * dest_low);
int address_char_unlonglong(const char * source, unsigned long long * dest_full, unsigned long * dest_high, unsigned long * dest_low);                                          
extern int dec_char_unchar(char * source, unsigned char * destine);
extern int dec_char_unlong(char * source, unsigned long * destine);
extern int dec_char_double(char * source, double * destine);
extern int strtrim(char*);
extern int convert_oid(char *str, unsigned short *oid);
extern int isInvalidPF(char * platform);
extern int getCutString(float f, char* result);

extern int start_iSMSMCfg(char * arr_name, char * cmd_name, int fun_no, int error_no, iSMSMCfg_APIinfo_t * api_info, int restart,int nounlock,int force);
extern int stop_iSMSMCfg(char * cmd_name, int fun_no, int error_no, iSMSMCfg_APIinfo_t* api_info, int nounlock, int restart);
extern int stop_iSMSMCfg_exception(char * cmd_name, int fun_no, int error_no, iSMSMCfg_APIinfo_t* api_info, int nounlock, int restart);
//added by liyb 20050905  , used to convert pool capacity
extern int Char8ToInt64(char * , unsigned long long *);
//added by liyb 20050905  , used to convert pool capacity
extern int hex4toushort(char *  , unsigned short * );
#endif /* _GENERAL_H */
