/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

public interface CollectionConst {
    public static final String cvsid 
            = "@(#) $Id: CollectionConst.java,v 1.6 2007/04/03 05:33:06 caows Exp $";    
    public static final int KILOBYTE = 1024;
    public static final int MILLION = 1024 * 1024;
    public static final int BLOCK_SIZE = 4096;
    public static final String STATIS_SAMPLING_TARGETID =
        "statis_sampling_targetid";
    public final static String PATH_OF_CHECKED_GIF =
        "/nsadmin/images/nation/check.gif";
    public static final String RESOURCE_KEY_LOWSPACE =
        "statis.sampling.lowspace_alert";
    public static final String RESOURCE_KEY_COMMON_SUCCESS =
        "common.alert.done";
    public static final String RESOURCE_KEY_COMMON_FAILED =
        "common.alert.failed";
    public static final String RESOURCE_KEY_OFF2ON_INFO =
        "statis.sampling.start_alert";
    public static final String PERIOD_SETTING_FAILED =
        "Failed to change stock period.";
    public static final String INTERVAL_SETTING_FAILED =
        "Failed to change interval.";
    public static final String TARGET_TYPE_NAS = "NAS";
    public static final String TARGET_TYPE_IPSAN = "IPSAN";
    public static final String TARGET_TYPE_CLUSTER = "CLUSTER";
    public static final String COLITEMID_ISCSI_AUTH = "iSCSI_Auth";
    public static final String COLITEMID_ISCSI_ISCSI_SESSION = "iSCSI_Session";
    public static final String COLITEMID_CPU_STATES = "CPU_States";
    public static final String COLITEMID_DISK_IO = "NAS_LV_IO";
    public static final String COLITEMID_FILESYSTEM = "Filesystem";
    public static final String COLITEMID_NETWORK = "Network_IO";
    public static final String COLITEMID_ANTI_VIRUS_SCAN = "Anti_Virus_Scan";
    public static final String DLINE = "--";
    public static final String RPQ_NUM = "0002";
    public static final String FILESYSTEM_RATE= "Filesystem(Rate)";
    public static final String SERVERPROTECT_LICENSE = "nvavs";
    public static final String EXCEPTION_MSG1 = "File lock is failed.";
    public static final String EXCEPTION_MSG2= " for lock.";
    public static final String EXCEPTION_ERRCODE_01 = "0x12800001";
    public static final String EXCEPTION_ERRCODE_02 = "0x12800002";
    public static final String EXCEPTION_ERRCODE_03 = "0x12800003";
    public static final String EXCEPTION_ERRCODE_04 = "0x12800004";
    public static final String EXCEPTION_ERRCODE_05 = "0x12800005";
    public static final String EXCEPTION_ERRCODE_06 = "0x12800006";
}