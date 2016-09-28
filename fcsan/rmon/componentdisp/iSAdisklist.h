/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(CVS_HEADER)
#if !defined(RCSID_iSAdisklist_H)
#define RCSID_iSAdisklist_H
#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklist.h,v 1.2305 2007/05/09 07:33:57 liuyq Exp $"
#else
#if !defined(lint)
static char *iSAdisklist_cvsid = "@(#) $Id: iSAdisklist.h,v 1.2305 2007/05/09 07:33:57 liuyq Exp $";
#endif
#endif
#endif
#endif

#ifndef _ISADISKLIST_H
#define _ISADISKLIST_H

#include "iSMSMApi.h"
#include "iSMSMerr.h"

/* Usage Info */
#define USAGE_FOR_D "Usage: iSAdisklist -d [-lcount list_count]"
#define USAGE_FOR_DS "Usage: iSAdisklist -ds -aid array_id"
#define USAGE_FOR_DAP "Usage: iSAdisklist -dap -aid array_id [-lcount list_count]"
#define USAGE_FOR_DAL "Usage: iSAdisklist -dal -aid array_id [-lcount list_count]"
#define USAGE_FOR_DP "Usage: iSAdisklist -dp -aid array_id"
#define USAGE_FOR_DD "Usage: iSAdisklist -dd -aid array_id"
#define USAGE_FOR_L "Usage: iSAdisklist -l -aid array_id [-ldset ldset_id | -port port_no | -pool] [-lcount list_count][-detail]"
#define USAGE_FOR_LP "Usage: iSAdisklist -lp -aid array_id -nld ld_no [-lcount list_count]"
#define USAGE_FOR_LS "Usage: iSAdisklist -ls -aid array_id -nld ld_no"
#define USAGE_FOR_LAL "Usage: iSAdisklist -lal -aid array_id -nld ld_no [-lcount list_count]"
#define USAGE_FOR_LAP "Usage: iSAdisklist -lap -aid array_id -nld ld_no [-lcount list_count]"
#define USAGE_FOR_P "Usage: iSAdisklist -p -aid array_id [-lcount list_count]"
#define USAGE_FOR_PL "Usage: iSAdisklist -pl -aid array_id -npd pd_no [-lcount list_count]"
#define USAGE_FOR_PD "Usage: iSAdisklist -pd -aid array_id -npd pd_no"
#define USAGE_FOR_C "Usage: iSAdisklist -c -aid array_id [-lcount list_count]"
#define USAGE_FOR_E "Usage: iSAdisklist -e -aid array_id [-lcount list_count]"


#define USAGE_FOR_POOL "Usage: iSAdisklist -pool -aid array_id [-lcount list_count]"///replaced by liyb 20050829
//#define USAGE_FOR_POOLD "Usage: iSAdisklist -poold -aid array_id -pno pool_no"///replaced by liyb 20050829
#define USAGE_FOR_POOLP "Usage: iSAdisklist -poolp -aid array_id -pno pool_no  [-lcount list_count]"///replaced by liyb 20050829
#define USAGE_FOR_POOLL "Usage: iSAdisklist -pooll -aid array_id -pno pool_no  [-lcount list_count]"///replaced by liyb 20050829
#define USAGE_FOR_LPOOL "Usage: iSAdisklist -lpool -aid array_id -nld ld_no "///replaced by liyb 20050829

#define USAGE_FOR_O  "Usage: iSAdisklist -o -aid array_id [-lcount list_count]"
#define USAGE_FOR_OL "Usage: iSAdisklist -ol -aid array_id -oid owner_id [-lcount list_count]"
#define USAGE_FOR_OS "Usage: iSAdisklist -os -aid array_id -oname owner_name [-detail] [-lcount list_count]"
#define USAGE_FOR_PF "Usage: iSAdisklist -pf -aid array_id [-lcount list_count]"
#define USAGE_FOR_HELP "Usage: iSAdisklist -?"

 
/* Option */
#define OPTION_D "-d"
#define OPTION_DS "-ds"
#define OPTION_DAP "-dap"
#define OPTION_DAL "-dal"
#define OPTION_DP "-dp"
#define OPTION_DD "-dd"
#define OPTION_L "-l"
#define OPTION_LP "-lp"
#define OPTION_LS "-ls"
#define OPTION_LAL "-lal"
#define OPTION_LAP "-lap"
#define OPTION_P "-p"
#define OPTION_PL "-pl"
#define OPTION_PD "-pd"
#define OPTION_C "-c"
#define OPTION_E "-e"


#define OPTION_POOL "-pool"//replaced by liyb 2002050829 
//#define OPTION_POOLD "-poold"//replaced by liyb 2002050829 
#define OPTION_POOLP "-poolp"//replaced by liyb 2002050829 
#define OPTION_POOLL "-pooll"//replaced by liyb 2002050829 
#define OPTION_LPOOL "-lpool"//replaced by liyb 2002050829 


#define OPTION_O "-o"
#define OPTION_OL "-ol"
#define OPTION_OS "-os"
#define OPTION_PF "-pf"
#define OPTION_HELP "-?"




/* Output Info */
#define NO_BASE_PD "-"   //added by liyb 20050829
#define DISK_ARRAY_LABEL "Disk_Array"
#define ARRAY_TYPE_LABEL "Array_Type"
#define ARRAY_ID_LABEL "Array_ID"
#define STATE_LABEL "State"
#define OBSERVATION_LABEL "Observation"
#define SAA_LABEL "SAA"
#define PRODUCT_ID_LABEL "Product_ID"
#define REV_LABEL "Rev"
#define SERIAL_NO_LABEL "Serial_No"
#define CAPACITY_LABEL "Capacity"
#define CONTROL_PASS1_LABEL "Control_path1"
#define CONTROL_PASS2_LABEL "Control_path2"
#define PATH1_STATE_LABEL "Path_state1"
#define PATH2_STATE_LABEL "Path_state2"
#define CROSS_CALL_LABEL "Cross_call"
#define ACCESS_LABEL "Access"
#define PORT_LABEL "Port"
#define MODE_LABEL "Mode"
#define STATE_LABEL "State"
#define LDSET_ID_LABEL "Ldset_ID"
#define TYPE_LABEL "Type"
#define PATH_LABEL "Path"
#define PRODUCT_LABEL "Product"
#define CNT_LABEL "Cnt"
#define LD_LABEL "LD"
#define PD_LABEL "PD"
#define DAC_LABEL "DAC"
#define DE_LABEL "DE"
#define DIVISION_LABEL "Division"
#define PD_NO_LABEL "PD_No"
#define RANK_LABEL "RANK"
#define POOL_LABEL "POOL"
#define LD_NO_LABEL "LD_No"
#define PROGRESSION_LABEL "Progression"
#define LDSET_LABEL "LD_SET"
#define LD_NAME_LABEL "LD_Name"
#define RAID_LABEL "RAID"
#define CACHE_LABEL "Cache"
#define PORT_NO_EQUAL_LABEL "Port No="
#define PORT_NO_LABEL "Port_No"
#define MBYTE_LABEL "MB"
#define CTL_RES_TYPE "Res_Type"
#define CTL_DIR_TYPE "Dir_Type"
#define CTL_NAME_LABEL "CTL_Name"
#define CTL_NO_LABEL "CTL_No"
#define COMPLEMENT_LABEL "Complement"
#define RANK_NO_LABEL "Rank_No"
#define STRIP_LABEL "Strip"
#define REBUILDING_TIME_LABEL "Rebuilding_time"
#define REMAIN_CAPACITY_LABEL "Remain_Capacity"
#define EXPANDING_TIME_LABEL "Expanding_time"
#define CURRENT_OWNER_LABEL "Current_owner"
#define DEFAULT_OWNER_LABEL "Default_owner"
#define PATH_CNT_LABEL "Path_cnt"
#define MULTIRANK_LABEL "MultiRANK"
#define SPIN_LABEL "Spin"
#define AUTO_ASSIGN_LABEL "Auto Assign"
#define START_ADDR_LABEL "Start_addr"
#define PARTITION_LABEL "Partition"
#define LUN_LABEL "LUN"
#define RESERVE_LABEL "Reserve"
#define DVR_LABEL "DVR"
#define USER_SYS_CODE_LABEL "User_sys_code"
#define PROTOCOL_LABEL "Protocol"
#define OWNER_ID_LABEL "Owner_ID"
#define PLATFORM_LABEL "Platform"
#define WWN_LABEL "WWn"
#define OWNER_NAME_LABEL "Owner_name"
#define PATTERN_LABEL "Pattern"
#define PF_TYPE_LABEL "Pf_type"
#define PF_INFO_LABEL "Pf_info"
#define PF_NAME_LABEL "Pf_name"
#define ABBREVIATION_LABEL "Abbreviation"
#define WWNN_LABEL "WWNN"  
#define POOL_NO_LABEL "POOL_No"  
#define POOL_NAME_LABEL "POOL_Name"  
#define BASE_PD_LABEL "Base_pd"
#define PD_TYPE_LABEL "type"


#define RAID_TYPE6 0x21
#define POOL_EXPANDING  0x10
//end add


/* product */
#define PRODUCT_DDR "DynamicDataReplication"
#define PRODUCT_RDR "RemoteDataReplocation"
#define PRODUCT_PERF "iStorageManager/PerforMate"
#define PRODUCT_REP_CONTROL "iStorageManager/ReplicationControl"
#define PRODUCT_ACCESS_CONTROL "AccessControl(WWN)"
#define PRODUCT_PERF_OPT "PerforSure"
#define PRODUCT_REALLOCATION_CONTROL "iStorageManager/ReallocationControl"
#define PRODUCT_POSTSCRIPT_NOLIM_VALUE 0x00
#define PRODUCT_POSTSCRIPT_NOLIM_DESC "nolim"
#define PRODUCT_POSTSCRIPT_NONE_VALUE 0xff
#define PRODUCT_FIELD_WIDTH 40
#define PRODUCT_ROW_INVISIBLE_VALUE 0x00

/* product state */
#define STATE_POSTSCRIPT_PP_DESC "pp"
#define STATE_POSTSCRIPT_CP_VALUE 0xff
#define STATE_POSTSCRIPT_CP_DESC "cp"
#define STATE_POSSIBLE "possible"
#define STATE_IMPOSSIBLE_DESC "not available"
#define STATE_IMPOSSIBLE_VALUE 0x01
#define STATE_POSSIBLE_DESC "available"
#define STATE_POSSIBLE_VALUE 0x02

/* unit */
#define UNIT_CONVERSION_BASE 1024    

/* table */
#define TABLE_COL_SEPARATOR "\t"   //change the const from "  " to "\t" by liyb 20050829
#define TABLE_FULL_WIDTH 80
#define TABLE_LINE_SYMBOL '-'

/*add iSM2.1 beging by yangzf */
#define  BLANK_LABEL "-"
#define  NO_MONITORING  "no_monitoring"
/*add iSM21. end */

/* cross call */
#define CROSS_CALL_NOT_SUPPORT "-"
#define CROSS_CALL_OFF "OFF"
#define CROSS_CALL_ON "ON"  

/* access control */
#define ACCESS_CONTROL_OFF "OFF"
#define ACCESS_CONTROL_ON "ON"

/* port access mode */
#define ACCESS_MODE_WNN "WWN"
#define ACCESS_MODE_PORT "Port" 
#define ACCESS_MODE_UNKNOWN "unknown" 

/* port matter */
#define PORT_MATTER_READY "ready"
#define PORT_MATTER_OFFLINE "offline"
#define PORT_MATTER_FAULT "fault" 
#define PORT_MATTER_NOLICENCE "no_licence"

/* array state */
#define ARRAY_STATE_READY_VALUE 0x00
#define ARRAY_STATE_READY_DESC "ready"
#define ARRAY_STATE_ATTENTION_VALUE 0x10
#define ARRAY_STATE_ATTENTION_DESC "attn"
#define ARRAY_STATE_FAULT_VALUE 0x20
#define ARRAY_STATE_FAULT_DESC "fault"

/* DAC state */
#define DAC_STATE_READY "ready"
#define DAC_STATE_OFFLINE "offline"
#define DAC_STATE_NOLICENCE "no_licence"
#define DAC_STATE_FAULT "fault"
#define DAC_STATE_REBUILDING "rebuilding"
#define DAC_STATE_CHARGE "charge"
#define DAC_STATE_WARNING1 "warning1"

/* observation */
#define OBSERVATION_RUNNING_VALUE 0x00
#define OBSERVATION_RUNNING_DESC "running"
#define OBSERVATION_INIT_VALUE 0x14
#define OBSERVATION_INIT_DESC "init"
#define OBSERVATION_CONFIG_VALUE 0x15
#define OBSERVATION_CONFIG_DESC "config"
#define OBSERVATION_TERM_VALUE 0x13
#define OBSERVATION_TERM_DESC "term"
#define OBSERVATION_STOP_VALUE 0x10
#define OBSERVATION_STOP_DESC "stop"
#define OBSERVATION_STOP_M_VALUE 0x12
#define OBSERVATION_STOP_M_DESC "stop(m)"
#define OBSERVATION_STOP_F_VALUE 0x11
#define OBSERVATION_STOP_F_DESC "stop(f)"
#define OBSERVATION_WAIT_VALUE 0x16
#define OBSERVATION_WAIT_DESC "wait"

/* LD state */
#define LDSTATE_REDUCE_VALUE 0x10
#define LDSTATE_REDUCE "reduce"
#define LDSTATE_REBUILDING_VALUE 0x11
#define LDSTATE_REBUILDING "rebuilding"
#define LDSTATE_PREVENT_VALUE 0x12
#define LDSTATE_PREVENT "preventive copy"
#define LDSTATE_COPY_BACK_VALUE 0x13
#define LDSTATE_COPY_BACK "copy back"
#define LDSTATE_UNFORMATTED_VALUE 0x14
#define LDSTATE_UNFORMATTED "unformatted"
#define LDSTATE_FORMATTING_VALUE 0x15
#define LDSTATE_FORMATTING "formatting"
#define LDSTATE_FORMAT_FAIL_VALUE 0x16
#define LDSTATE_FORMAT_FAIL "format fail"
#define LDSTATE_EXPANDING_VALUE 0x18
#define LDSTATE_EXPANDING "expanding"
#define LDSTATE_EXPANDING_FAIL_VALUE 0x19
#define LDSTATE_EXPANDING_FAIL "expanding fail"
#define LDSTATE_MEDIA_ERROR_VALUE 0x21
#define LDSTATE_MEDIA_ERROR "media error"

/* watch state */
#define WATCH_STATE_MONITOR_ON 0x00
#define WATCH_STATE_MONITOR_OFF 0x10
#define WATCH_STATE_MONITOR_OFF_ERROR 0x11
#define WATCH_STATE_MONITOR_OFF_SEIZE 0x12
#define WATCH_STATE_STOP_PREPARATION 0x13
#define WATCH_STATE_START_PREPARATION 0x14
#define WATCH_STATE_SETTING 0x15

/* PD division */
#define PD_DIVISION_NONE "none"
#define PD_DIVISION_DATA "data"
#define PD_DIVISION_SPARE "spare"

/*control path state*/
#define PATH_STATE_OK "OK"
#define PATH_STATE_NG "NG"

/*NULL state*/
#define NULL_STATE "--"

/* PD state */
#define PD_STATE_READY_VALUE 0x00
#define PD_STATE_READY_DESC "ready"
#define PD_STATE_OFFLINE_VALUE 0x10
#define PD_STATE_OFFLINE_DESC "offline"
#define PD_STATE_REBUILDING_VALUE 0x11
#define PD_STATE_REBUILDING_DESC "rebuilding"
#define PD_STATE_POWERING_VALUE 0x12
#define PD_STATE_POWERING_DESC "powering up"
#define PD_STATE_FORMATTING_VALUE 0x13
#define PD_STATE_FORMATTING_DESC "formatting"
#define PD_STATE_FAULT_VALUE 0x20
#define PD_STATE_FAULT_DESC "fault"
#define PD_STATE_INVALID_VALUE 0x21
#define PD_STATE_INVALID_DESC "invalid"




//some info about pool   liyb 2050830
#define POOL_NUM_MASK_DESC "--"
#define POOL_NAME_MASK_DESC "--"

//pd type ,added by liyb 20051214
#define PD_TYPE_FC_VALUE 0x00
#define PD_TYPE_FC_DESC "FC"
#define PD_TYPE_SATA_VALUE 0x01
#define PD_TYPE_SATA_DESC  "SATA"
#define PD_TYPE_SAS_VALUE 0x02
#define PD_TYPE_SAS_DESC  "SAS"

//expand state
#define POOL_STATE_ID_END 0x00 
//Normal End/Not Expansion/Expansion Canceled  
#define POOL_STATE_READY "ready"
#define POOL_STATE_REDUCE "reduce"
#define POOL_STATE_REBUILDING "rebuilding"
#define POOL_STATE_PREVENTIVE_COPY "preventive copy"
#define POOL_STATE_COPY_BACK "copy back"
#define POOL_STATE_FAULT "fault"
#define POOL_MEDIA_ERROR "media error"


#define POOL_STATE_ID_EXPANDING_NORMAL 0x10 
#define POOL_STATE_EXPANDING_NORMAL  "Expanding(Normal)"  

#define POOL_STATE_ID_EXPANDING_SUSPEND 0x11
#define POOL_STATE_EXPANDING_SUSPEND "Expanding(SuspendPD)"

#define POOL_STATE_ID_RAID_CONVERSIONING_NORMAL 0x20 
#define POOL_STATE_RAID_CONVERSIONING_NORMAL "RAID Conversioning(Normal)"

#define POOL_STATE_ID_RAID_CONVERSIONING_SUSPEND 0x21 
#define POOL_STATE_RAID_CONVERSIONING_SUSPEND "RAID Conversioning(SuspendPD)"

#define POOL_STATE_ID_FAIL 0x31
#define POOL_STATE_FAIL "Expand Fail"




/* DAC type */
#define DAC_TYPE_HD_RD_DD_ETC_VALUE_ONE 0x01
#define DAC_TYPE_HD_RD_DD_ETC_VALUE_TWO 0x02
#define DAC_TYPE_CHE_VALUE 0x03
#define DAC_TYPE_SVP_VALUE 0x04
#define DAC_TYPE_DAC_PS_VALUE 0x05
#define DAC_TYPE_DAC_BBU_VALUE 0x06
#define DAC_TYPE_DAC_FANU_VALUE 0x07
#define DAC_TYPE_DAC_FANL_VALUE 0x08
#define DAC_TYPE_DAC_TEMP_ALM_VALUE 0x09
#define DAC_TYPE_DAC_BB_VALUE 0x0A 
#define DAC_TYPE_BC_JB_VALUE 0x0B
#define DAC_TYPE_PANEL_VALUE 0x0C
#define DAC_TYPE_PORT_NO_VALUE_ONE 0x01
#define DAC_TYPE_PORT_NO_VALUE_TWO 0x02
#define DAC_TYPE_CACHE_VALUE 0x03

/* DIR type */
#define DIR_TYPE_HD_VALUE 0x10
#define DIR_TYPE_RD_VALUE 0x20
#define DIR_TYPE_DD_VALUE 0x30

/* CTL name */
#define CTL_NAME_HD "HD"
#define CTL_NAME_RD "RD"
#define CTL_NAME_DD "DD"
#define CTL_NAME_ETC "ETC"
#define CTL_NAME_CHE "CHE"
#define CTL_NAME_SVP "SVP"
#define CTL_NAME_DAC_PS "DAC_PS"
#define CTL_NAME_DAC_BBU "DAC_BBU"
#define CTL_NAME_DAC_FANU "DAC_FANU"
#define CTL_NAME_DAC_FANL "DAC_FANL"
#define CTL_NAME_DAC_TEMP_ALM "DAC_TEMP_ALM"
#define CTL_NAME_DAC_BB "DAC_BB"
#define CTL_NAME_BC_JB "BC_JB"
#define CTL_NAME_PANEL "PANEL"
#define CTL_NAME_DE_ADP "DE_ADP"
#define CTL_NAME_DE_PS "DE_PS"  
#define CTL_NAME_DE_FAN "DE_FAN"
#define CTL_NAME_DE_TEMP_FAN "DE_TEMP_ALM"
#define CTL_NAME_DE_BB "DE_BB"
#define CTL_NAME_EC_JB "EC_JB"


/* type definition */
struct LdNo
{
    unsigned short ld_no;
    struct LdNo *next;
} ;

typedef struct LdNo LdNoNode;

struct LdNoList
{
    unsigned short numOfLd;
    struct LdNoList * down;
    struct LdNo * right;
};

typedef struct LdNoList LdPatternListHeadNode;


extern int diskList_d(unsigned int);
extern int diskList_ds(unsigned char);
extern int diskList_dap(unsigned char, unsigned int);
extern int diskList_dal(unsigned char, unsigned int);
extern int diskList_dp(unsigned char);
extern int diskList_dd(unsigned char);
extern int diskList_p(unsigned char,unsigned int);
extern int diskList_pl(unsigned char ,unsigned char ,unsigned char ,unsigned int);
extern int diskList_pd(unsigned char ,unsigned char ,unsigned char );
extern int diskList_pool(unsigned char ,unsigned short);  //diskList_r(unsigned char ,unsigned short);   changed by liyb 20050831
extern int diskList_pooll(unsigned char , unsigned short, unsigned int  );//diskList_rl(unsigned char , unsigned char , unsigned char ,unsigned int );
extern int diskList_poolp(unsigned char , unsigned short, unsigned int );//diskList_rp(unsigned char , unsigned char , unsigned char ,unsigned int )
extern int diskList_l_nooption(unsigned char , unsigned int , int);
extern int diskList_l_ldset(unsigned char , unsigned int ,unsigned short , int);
extern int diskList_l_port(unsigned char , unsigned int , unsigned char ,unsigned char , int);
extern int diskList_l_pool(unsigned char , unsigned int ,int);
extern int diskList_lp(unsigned char ,unsigned short,unsigned int );
extern int diskList_lap(unsigned char ,unsigned short ,unsigned int );
extern int diskList_lal(unsigned char ,unsigned short ,unsigned int );
extern int diskList_ls(unsigned char ,unsigned short );
extern int diskList_c(unsigned char ,unsigned int );
extern int diskList_e(unsigned char ,unsigned int );
extern int diskList_lpool(unsigned char , unsigned short ); ////changed by liyb 20050905
extern int diskList_o(unsigned char array_id,unsigned int lcount);
extern int diskList_ol(unsigned char array_id,unsigned short oid, unsigned int lcount);
extern int diskList_os(unsigned char array_id,char* owner_name, int detail, unsigned int lcount); 
extern int diskList_pf(unsigned char array_id,unsigned int lcount);
extern void releasePatternList(LdPatternListHeadNode *);
extern int load_pattern(unsigned char,unsigned short ,unsigned int , LdPatternListHeadNode ** ,unsigned short *);
extern int outPdDivision(unsigned char);
extern int outPdState(unsigned char);
extern int outLDInfo(unsigned char , iSMSMLd , unsigned int * , int , int , unsigned char );//outLDInfo(unsigned char,iSMSMLd,unsigned int*,int,int);
extern int outLDPartInfo(iSMSMLd , unsigned int , unsigned char );
//added by liyb 20050905
extern int getPoolInfo(unsigned short pool_no, unsigned char array_id, iSMSMPool ** poolData, iSMSMoutDataInfo * ptr_pool_o_inf, unsigned int * loop_count_ldset, int cmdCodeFunc, int cmdCodeType);
//added by liyb 20050905
extern int getRaidtype(unsigned char raid_type);
//added by liyb 20050906
extern void printLDHeadInfo(void);
//added by liyb 20050906
extern void printPoolHeadInfo(void);
//added by liyb 20050906
extern int getStateDescribe(unsigned char expansion_state_id, unsigned char matter_id, char * * state);
#endif /* _ISADISKLIST_H */
