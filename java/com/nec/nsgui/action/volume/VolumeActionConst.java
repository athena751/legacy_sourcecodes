/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

public interface VolumeActionConst {
    public static final String cvsid =
        "@(#) $Id: VolumeActionConst.java,v 1.17 2008/05/24 12:11:41 liuyq Exp $";
   
   public final static String  APPLICATION_VOLUME_VOLUMEINFO = "VOLUME_APPLICATION_VOLUMEINFO";
   public final static String  APPLICATION_VOLUME_TIP = "VOLUME_APPLICATION_TIP";
   public final static String  APPLICATION_VOLUME_PROCESS = "VOLUME_APPLICATION_PROCESS";
   public final static String  APPLICATION_VOLUME_CREATE_RESULT_H3 = "VOLUME_APPLICATION_RESULT_H3"; 
   
   public final static String  APPLICATION_VOLUME_NV_LVM = "NV_LVM_"; 
   
   public final static String  VOLUME_INFO_VOLUME_NAME = "VOLUME_INFO_NAME"; 
   public final static String  SESSION_VOLUME_INFO_OBJ = "VOLUME_INFO_OBJ"; 
   public final static String  SESSION_VOLUME_TABLE_MODE = "VOLUME_TABLE_MODE"; 
   public final static String VOLUME_BATCH_CREATE_NODE_NUM = "VOLUME_BATCH_CREATE_NODE_NUM";
   
   public final static String VOLUME_NAS_LV_IO = "NAS_LV_IO";
   public final static String VOLUME_FILE_SYSTEM = "Filesystem";
   public final static String VOLUME_FILE_SYSTEM_QUANTITY = "Filesystem_Quantity";
   public final static String VOLUME_FLAG_EXTEND = "VOLUME_FLAG_FOR_SELECT_LUN_SIZE";
   public final static String SESSION_NV_ASYNC = "NV_ASYNC";
   public final static String SESSION_CURRENT_EXPORTGROUP_ASYNC = "CURRENT_EXPORTGROUP_ASYNC";
   public final static String SESSION_ASYNC_ERROR = "ASYNC_ERROR";
   public final static String PREFIX_REPLICA_ERROR = "0x124";
   public final static String ASYNC_NO_ERROR = "0x00000000";
   public final static String SESSION_FROM = "VOLUME_FROM";
   public final static String SESSION_ASYNC_STATUS_NORMAL = "normal";
   public final static String SESSION_WP_LICENSE = "VOLUME_WRITE_PROTECTED_LICENSE";
  
   public final static String VOLUME_MAX_SIZE = "133120"; // 130TB
   public final static String VOLUME_SIZE_20TB = "20480"; // 20TB
   
   public final static String SESSION_VOL_LIC_EXCEEDLICENSE = "volLic_exceedLicense";
   public final static String SESSION_VOL_LIC_LICENSECAP = "volLic_licenseCap";
   public final static String SESSION_VOL_LIC_TOTALFSCAP = "volLic_totalFSCap";
   public final static String SESSION_MACHINE_PROCYON = "machine_isProcyon";
   public final static String SESSION_DISKIARRAY_CONDORSERIES = "VOLUME_IS_CONDOR_SERIES";
   public final static String UNIT_GB = "gb";
   public final static String UNIT_TB = "tb";
   
   public final static String DOUBLE_HYPHEN = "--";
   public final static String LICENSE_UNLIMITED = "nolimit";
   public final static String SESSION_DISPLAY_LIC_NOLIMIT = "volLic_DISPLAY_UNLIMITED_LICENSE";
   
   public final static String CONST_DISPLAYMVLUN         = "DISPLAY_MVLUN";
   public final static String CONST_NOTDISPLAYMVLUN      = "NOT_DISPLAY_MVLUN";
   public final static String VOLUME_FLAG_SHOWLUN4SYNCFS = "VOLUME_FLAG_SHOWLUN4SYNCFS";
}
