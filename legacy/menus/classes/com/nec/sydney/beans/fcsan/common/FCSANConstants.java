/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: FCSANConstants.java,v 1.2308 2008/09/09 03:24:26 pizb Exp $";
 */

package com.nec.sydney.beans.fcsan.common;

public interface FCSANConstants
{

        public static String SEPARATED_LINE = "-------------";
        public static String DISK_ARRAY = "Disk_Array";
        public static String SESSION_RANK_LIST = "ranklist";
        public static String SESSION_PD_LIST = "pdlist";
        public static String SESSION_RANK_SUMMARY = "ranksummary";
        public static String SESSION_LVM_LIST = "lvmlist";
        //this session store the disk model(mirror or general)
        public static String SESSION_DISK_MODEL = "diskmodel";
        public static int FCSAN_SUCCESS = 0;
        public static String DISKLIST_CMD_NAME="iSAdisklist";
        public static String CMD_SUDO = "sudo";  
        public static String CMD_RSH = "rsh";  
        public static String CMD_LD_USED = "sudo /home/nsadmin/bin/ld_used.pl";  
        public static int LINE6_PER_PAGE = 6;
        public static int LINE10_PER_PAGE = 10;
        //command is list.....
        public static String CMD_DISKLIST = "/opt/nec/nsadmin/sbin/iSAdisklist";
        public static String CMD_DISKLIST_DS = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -ds -aid"; 
        public static String CMD_DISKLIST_LR = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -lr -aid";
        public static String CMD_DISKLIST_LPOOL = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -lpool -aid";
        public static String CMD_DISKLIST_OS = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -os -aid";  
        public static String CMD_DISKLIST_DD = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -dd -aid";
        public static String CMD_DISKLIST_DAP= "sudo /opt/nec/nsadmin/sbin/iSAdisklist -dap -aid";
        public static String CMD_DISKLIST_DAL= "sudo /opt/nec/nsadmin/sbin/iSAdisklist -dal -aid";
        public static String CMD_DISKLIST_DP= "sudo /opt/nec/nsadmin/sbin/iSAdisklist -dp -aid";
        public static String CMD_DISKLIST_D = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -d";
        public static String CMD_DISKREFRESH = "sudo /opt/nec/nsadmin/sbin/iSArefreshlist -aid";
        public static String CMD_DISKLIST_L = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -l -aid";
        public static String CMD_DISKLIST_LS = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -ls -aid";
        public static String CMD_DISKLIST_LAP = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -lap -aid";
        public static String CMD_DISKLIST_LAL = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -lal -aid";
        public static String CMD_DISKLIST_LP= "sudo /opt/nec/nsadmin/sbin/iSAdisklist -lp -aid";
        public static String CMD_DISKLIST_P= "sudo /opt/nec/nsadmin/sbin/iSAdisklist -p -aid";
        public static String CMD_DISKLIST_PD = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -pd -aid";
        public static String CMD_DISKLIST_PL = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -pl -aid";
        public static String CMD_DISKLIST_C = "sudo /opt/nec/nsadmin/sbin/iSAdisklist -c -aid";
        public static String CMD_DISKLIST_E= "sudo /opt/nec/nsadmin/sbin/iSAdisklist -e -aid";
        public static String CMD_DISKLIST_R="sudo /opt/nec/nsadmin/sbin/iSAdisklist -r -aid";
        public static String CMD_DISKLIST_POOL="sudo /opt/nec/nsadmin/sbin/iSAdisklist -pool -aid";
        public static String CMD_DISKLIST_RL="sudo /opt/nec/nsadmin/sbin/iSAdisklist -rl -aid";
        public static String CMD_DISKLIST_POOLL="sudo /opt/nec/nsadmin/sbin/iSAdisklist -pooll -aid";
        public static String CMD_DISKLIST_RP="sudo /opt/nec/nsadmin/sbin/iSAdisklist -rp -aid";
        public static String CMD_DISKLIST_POOLP="sudo /opt/nec/nsadmin/sbin/iSAdisklist -poolp -aid";
        public static String CMD_DISKLIST_O="sudo /opt/nec/nsadmin/sbin/iSAdisklist -o -aid";
        public static String CMD_DISKLIST_OL="sudo /opt/nec/nsadmin/sbin/iSAdisklist -ol -aid";
        public static String CMD_DISKLIST_RD="sudo /opt/nec/nsadmin/sbin/iSAdisklist -rd -aid";
        //command is setname...
        public static String CMD_DISKSETNAME_SL = "sudo /opt/nec/nsadmin/sbin/iSAsetname -sl -aid";
        public static String CMD_DISKSETNAME_LS = "sudo /opt/nec/nsadmin/sbin/iSAsetname -ls -aid";
        public static String CMD_DISKSETNAME_SA = "sudo /opt/nec/nsadmin/sbin/iSAsetname -sa -aid";
        public static String CMD_DISKSETNAME_SP = "sudo /opt/nec/nsadmin/sbin/iSAsetname -sp -aid";
        public static String CMD_DISKSETNAME_SPOOL = "sudo /opt/nec/nsadmin/sbin/iSAsetname -spool -aname";
        
        //command is setmon....
        public static String CMD_DISKSETMON_START = "sudo /opt/nec/nsadmin/sbin/iSAsetmon -start -aid";
        public static String CMD_DISKSETMON_STOP= "sudo /opt/nec/nsadmin/sbin/iSAsetmon -stop -aid";
        public static String CMD_DISKSETMON_FSTOP= "sudo /opt/nec/nsadmin/sbin/iSAsetmon -fstop -aid";
        //command is setrank...
        public static String CMD_DISKSETRANK_E = "sudo /opt/nec/nsadmin/sbin/iSAsetrank -e -aname";
        public static String CMD_DISKSETRANK_B = "sudo /opt/nec/nsadmin/sbin/iSAsetrank -b -aname";
        public static String CMD_DISKSETRANK_R = "sudo /opt/nec/nsadmin/sbin/iSAsetrank -r -aname";
        public static String CMD_DISKSETPOOL_R = "sudo /opt/nec/nsadmin/sbin/iSAsetpool -r -aname";
        public static String CMD_DISKSETRANK_C = "sudo /opt/nec/nsadmin/sbin/iSAsetrank -c -aname";
        public static String CMD_DISKSETPOOL_C = "sudo /opt/nec/nsadmin/sbin/iSAsetpool -c -aname";
        //command is rbrank...
        public static String CMD_DISKRBRANK_RP = "sudo /opt/nec/nsadmin/sbin/iSArbrank -rp -aname";
        public static String CMD_DISKRBRANK_RS = "sudo /opt/nec/nsadmin/sbin/iSArbrank -rs -aname";    
        //command is setspare...
           public static String CMD_DISKSETSPARE_B = "sudo /opt/nec/nsadmin/sbin/iSAsetspare -b -aname";
        public static String CMD_DISKSETSPARE_R = "sudo /opt/nec/nsadmin/sbin/iSAsetspare -r -aname";  
        //command is setld...
        public static String CMD_DISKSETLD_R = "sudo /opt/nec/nsadmin/sbin/iSAsetld -r -aname";
        public static String CMD_DISKSETLD_B = "sudo /opt/nec/nsadmin/sbin/iSAsetld -b -aname";  
        public static String CMD_DISKSETARRAY_CLD = "sudo /opt/nec/nsadmin/sbin/iSAsetarray -cld -aname"; 
         public static String CMD_DISKSETARRAY_CA = "sudo /opt/nec/nsadmin/sbin/iSAsetarray -ca -aname";
        public static String CMD_DATE = "date +%Y%m%d%T";
        //command is setldset...
        public static String CMD_DISKSETLDSET_D = "sudo /opt/nec/nsadmin/sbin/iSAsetldset -d -aname";
        public static String CMD_DISKSETLDSET_B = "sudo /opt/nec/nsadmin/sbin/iSAsetldset -b -aname";
        public static String CMD_DISKSETLDSET_LS = "sudo /opt/nec/nsadmin/sbin/iSAsetldset -ls -aname";
        public static String CMD_DISKSETLDSET_LR = "sudo /opt/nec/nsadmin/sbin/iSAsetldset -lr -aname";
        public static String CMD_DISKSETLDSET_PS = "sudo /opt/nec/nsadmin/sbin/iSAsetldset -ps -aname";
        public static String CMD_DISKSETLDSET_PE = "sudo /opt/nec/nsadmin/sbin/iSAsetldset -pe -aname";
        public static String CMD_DISKSETLDSET_PR = "sudo /opt/nec/nsadmin/sbin/iSAsetldset -pr -aname";
        //command is setacctl...
        public static String CMD_DISKSETACCTL_A = "sudo /opt/nec/nsadmin/sbin/iSAsetacctl -a -aname";
        public static String CMD_DISKSETACCTL_M = "sudo /opt/nec/nsadmin/sbin/iSAsetacctl -m -aname";

        //special command
        public static String CMD_ISMRC_LDLIST_DE = "sudo /usr/sbin/iSMrc_ldlist -de";
        public static String CMD_ISMRC_PAIR_UNPAIR = "sudo /usr/sbin/iSMrc_pair -unpair";

        //ISM*** command
        public static String CMD_ISMRC_LDLIST = "/usr/sbin/iSMrc_ldlist";  
        public static String CMD_ISMRC_QUERY = "/usr/sbin/iSMrc_query";
        public static String CMD_ISMRC_ARRAYINFO = "/usr/sbin/iSMrc_arrayinfo";
        public static String CMD_ISMRC_PAIR = "/usr/sbin/iSMrc_pair";

        //check file command
        public static String CMD_CHECK_MODEL = "/home/nsadmin/bin/fcsan_checkmodel.pl";
        
        public static String CMD_INITLUN = "sudo /home/nsadmin/bin/ld_initlun.pl";
        public static String CMD_DELLUN = "sudo /home/nsadmin/bin/ld_dellun.pl";
        
        public static String CMD_ISFIRST_ARY = "sudo /home/nsadmin/bin/volume_isosdisk.pl";
        public static String SCRIPT_RESTART_ISMSVR = "sudo /home/nsadmin/bin/volume_restartismsvr.pl";
        
        //FCSAN's state.
        public static String FCSAN_STATE_REDAY = "ready";
        public static String FCSAN_STATE_OFFLINE = "offline";
        public static String FCSAN_STATE_FAULT = "fault";
        public static String FCSAN_STATE_NO_LICENCE = "no_licence";
        public static String FCSAN_STATE_ATTN = "attn";
        public static String FCSAN_STATE_RUNNING = "running";
        public static String FCSAN_STATE_UNKNOWN = "unknown";
        public static String FCSAN_STATE_INIT = "init";
        public static String FCSAN_STATE_CONFIG = "config";
        public static String FCSAN_STATE_TERM = "term";
        public static String FCSAN_STATE_STOP = "stop";
        public static String FCSAN_STATE_STOP_F = "stop(f)";
        public static String FCSAN_STATE_STOP_M = "stop(m)";
        public static String FCSAN_STATE_AVAILABLE = "available";
        public static String FCSAN_STATE_AVAILABLE_NOT = "not available";
        public static String FCSAN_STATE_AVAILABLE_NOT_CP = "not available(cp)";
        public static String FCSAN_STATE_AVAILABLE_NOT_PP = "not available(pp)";
        public static String FCSAN_STATE_REDUCE = "reduce";
        public static String FCSAN_STATE_PREVENTIVE_COPY = "preventive copy";
        public static String FCSAN_STATE_COPY_BACK = "copy back";
        public static String FCSAN_STATE_UNFORMATTED = "unformatted";
        public static String FCSAN_STATE_FORMATTING = "formatting";
        public static String FCSAN_STATE_FORMAT_FAIL = "format fail";
        public static String FCSAN_STATE_EXPANDING = "expanding";
        public static String FCSAN_STATE_EXPAND_FAIL = "expand fail";
        public static String FCSAN_STATE_MEDIA_ERROR = "media error";
        public static String FCSAN_STATE_REBUILDING = "rebuilding";
        public static String FCSAN_STATE_POWERING_UP = "powering up";
        public static String FCSAN_STATE_INVALID = "invalid";
        public static String FCSAN_STATE_WAIT = "wait";
        public static String FCSAN_STATE_SETUP = "setup";
        public static String FCSAN_STATE_NO_MONITORING = "no_monitoring";
        //FCSAN's type
        public static String FCSAN_TYPE_LD = "LD";
        public static String FCSAN_TYPE_PD = "PD";
        public static String FCSAN_TYPE_DAC = "DAC";
        public static String FCSAN_TYPE_DE = "DE";
        //FCSAN'S controller
        public static String FCSAN_CURRENT_OWNER_CONTROLLER1 = "controller1";
        public static String FCSAN_CURRENT_OWNER_CONTROLLER0 = "controller0";
        //FCSAN's deivision
        public static String FCSAN_DIVISION_DATA = "data";
        public static String FCSAN_DIVISION_SPARE = "spare";
        public static String FCSAN_DIVISION_NONE = "none";
        //FCSAN's ctl_name
        public static String FCSAN_CTL_CAPACITY = "Capacity";
        public static String FCSAN_CTL_NAME_HD = "HD";
        public static String FCSAN_CTL_RD = "RD";
        public static String FCSAN_CTL_DD = "DD";
        public static String FCSAN_CTL_CHE = "CHE";
        public static String FCSAN_CTL_SVP = "SVP";
        public static String FCSAN_CTL_DAC_PS ="DAC_PS";
        public static String FCSAN_CTL_DAC_BBU = "DAC_BBU";
        public static String FCSAN_CTL_DAC_FANU = "DAC_FANU";
        public static String FCSAN_CTL_DAC_FANL = "DAC_FANL";
        public static String FCSAN_CTL_DAC_TEMP_ALM = "DAC_TEMP_ALM";
        public static String FCSAN_CTL_DAC_BB = "DAC_BB";
        public static String FCSAN_CTL_BC_JB = "BC_JB";
        public static String FCSAN_CTL_PANEL = "PANEL";
        public static String FCSAN_CTL_ETC = "ETC";
        public static String FCSAN_CTL_DE_ADP = "DE_ADP";
        public static String FCSAN_CTL_DE_PS = "DE_PS";
        public static String FCSAN_CTL_DE_FAN = "DE_FAN";
        public static String FCSAN_CTL_DE_TEMP_ALM = "DE_TEMP_ALM";
        public static String FCSAN_CTL_DE_BB = "DE_BB";
        public static String FCSAN_CTL_EC_JB = "EC_JB";
        public static String FCSAN_CTL_PE_PS = "PE_PS";
        public static String FCSAN_NOMEAN_VALUE = "--";
        //FCSAN's ctl_name
        public static String FCSAN_ACC_MV = "MV";
        public static String FCSAN_ACC_MV_ATG = "MV(ATG)";
        public static String FCSAN_CTL_RV = "RV";
        public static String FCSAN_CTL_RV_ATG = "RV(ATG)";
        public static String IVKIND = "IV";
        public static String RVMVKIND = "RV/MV";
        public static String RVMVATGKIND = "RV/MV(ATG)";

        //others
        public static int NO_ERRORCODE = 255;
        public static String FCSAN_ACWWN = "AccessControl(WWN)";
        public static String FCSAN_WWN = "WWN";
        public static String FCSAN_REPLICATION = "replication";
        public static String FCSAN_RESERVE = "reserve";

/*
 *   modified by hujun on 19, June
 */
/*        public static int iSMSM_NOTREADY = -3;
        public static int iSMSM_SVR_NOTREADY = -11;
        public static int iSMSM_REPEAT_LDNUM = -31;
*/        
        public static int iSMSM_ARG_ERR             = -1    ;
                          
        public static int iSMSM_TRV_ERR            = -2    ;
                          
        public static int iSMSM_NOTREADY        = -3    ;
                          
        public static int iSMSM_TBL_NOTREADY    = -4    ;
                          
        public static int iSMSM_DSIZE_ERR        = -5    ;
                          
        public static int iSMSM_NOENTRY            = -6    ;
                          
        public static int iSMSM_RUNNING            = -7    ;
                          
        public static int iSMSM_NOTRUNNING        = -8    ;
                          
        public static int iSMSM_CFG_RUNNING        = -9    ;
                          
        public static int iSMSM_TIMEOUT            = -10;    
                          
        public static int iSMSM_SVR_NOTREADY    = -11;    
                          
        public static int iSMSM_SOCK_ERR        = -12;
                          
        public static int iSMSM_SYS_ERR            = -13;    
                          
        public static int iSMSM_SVR_ETC_ERR        = -14;
                          
        public static int iSMSM_ENTRY_OVER        = -15;
                          
        public static int iSMSM_CFG_DBLRUN        = -16;
                          
        public static int iSMSM_CFG_NOTSTART    = -17;
                          
        public static int iSMSM_ALREADY            = -18;
                          
        public static int iSMSM_NOCHANGE        = -19;
                          
        public static int iSMSM_MON_STARTRUN    = -20;
                          
        public static int iSMSM_MON_STOPRUN    = -21;
                          
        public static int iSMSM_MON_RECOVERY    = -22;
                          
        public static int iSMSM_TBL_NOENTRY        = -23;
                          
        public static int iSMSM_FUNCNAV            = -24;
                          
        public static int iSMSM_NOLICENSE        = -25;
                          
        public static int iSMSM_RPL_SETTING        = -26;
                          
        public static int iSMSM_MISMATCH        = -27;
                          
        public static int iSMSM_RESERVE_SETTING    = -28;
                          
        public static int iSMSM_DVR_SETTING        = -29;
                          
        public static int iSMSM_INVALID_VAL        = -30;
                          
        public static int iSMSM_EXIST            = -31;
                          
        public static int iSMSM_ETC_ERR            = -99;
        
        public static int iSMSM_NOSUPPORT_COMMAND = -32;
        
        public static int iSMSM_LDSET_FORBIDDEN = -33;
        
        public static int iSMSM_ACMODE_ERR       = -34;
// end 
// for iSM V2.1
        public static int iSMSM_INVALID_ARRAY       = -35;

        public static int iSMSM_TBL_UPDATE       = -36;

        public static int iSMSM_CONTROL_PATH       = -37;

        public static int iSMSM_SHUTDOWN       = -38;

        public static int iSMSM_ALMOST       = -39;

        public static int iSMSM_WARNING       = -40;

// end
        public static String ERROR_CODE = "error_code";

        public static int TOKENSCOUNTOFENDLINE = 2;
        public static int DISKLIST_LFIRSTLINECOUNT1 = 9;
        public static int DISKLIST_LFIRSTLINECOUNT2 = 10;
        public static int UNITCONSTANT = 1024;
        public static int TOKENSCOUNTOFISMRC_LDLIST_DE = 5;
        
        public static String SESSION_RANK_BIND_FROM = "SESSION_RANK_BIND_FROM";
        
        public static String RAID_6_4PQ = "6(4+PQ)";
        public static String RAID_6_8PQ = "6(8+PQ)";
        public static String RAID_1 = "1";
        public static String RAID_5 = "5";
        public static String RAID_10 = "10";
        public static String RAID_50 = "50";
        

}
