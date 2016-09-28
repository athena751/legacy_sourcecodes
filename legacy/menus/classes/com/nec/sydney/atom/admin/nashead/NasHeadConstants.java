/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */ 

package  com.nec.sydney.atom.admin.nashead;


import     com.nec.sydney.atom.admin.base.*;


public interface NasHeadConstants extends CommonConst {
    public static final String     cvsid = "@(#) $Id: NasHeadConstants.java,v 1.3 2004/06/04 08:03:37 baiwq Exp $";

    public static final int LD_LDCONF_NOT_EXIST = 0x00006101;
    public static final int LD_FAILED_TO_RUN_VGDISPLAY = 0x00006102;
    public static final int LD_LD_HAS_CREATED_T0_LV = 0x00006103;
    public static final int LD_FAILED_TO_RUN_LDHARDLN_1 = 0x00006104;
    public static final int LD_FAILED_TO_RUN_LDHARDLN_2 = 0x00006105;
    
    public static final int LD_ALERT_LD_EXIST = 0x00006201;
    public static final int LD_ALERT_STATUS_MAINTAIN = 0x00006202;
    public static final int LD_ALERT_WWNN_LUN_USED = 0x00006203;
    public static final int LD_ALERT_ADD_ROLLBACK_FAILED = 0x00006205;
    public static final int LD_AUTO_LINK_LD_IS_FULL_EXCEPTION = 0x00006206;
    public static final int STORAGE_NAME_EXIST_EXCEPTION = 0x00006207;
    
    public static final int  CONSTANT_GETDDMAP_FAILED = 0x00006301;
    public static final int  CONSTANT_LDCONF_NOT_EXIST_FOR_DELETE = 0x00006302;
    public static final int  CONSTANT_FAILED_TO_RUN_LDHARDLN_1 = 0x00006303;
    public static final int  CONSTANT_FAILED_TO_RUN_LDHARDLN_2 = 0x00006304;
    
    public static final int  CONSTANT_MAX_PORT_NUM = 4;
    public static final String CONSTANT_PORT_STATE_NML = "NML";
    public static final String CONSTANT_PORT_STATE_FLT = "FLT";
    public static final String CONSTANT_PORT_STATE_OFF = "---";
    public static final String SESSION_NAME_WWNN = "nashead_wwnn";
}

