/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

public interface ReplicationActionConst {
    public static final String cvsid = "@(#) $Id: ReplicationActionConst.java,v 1.4 2008/10/09 09:48:42 chenb Exp $";
    
    public static String SESSION_MOUNT_POINT = "replicaMountPoint";
    public static String SESSION_FILESET = "originalFilesetName";  //added by liyb
    public static String SESSION_VOLUME_INFO_4REPLI = "volumeInfo4Repli";
    
    public static int MAX_SNAPSHOT_NUM = 255;
    
    public static String DEFAULT_MINUTE = "0";
    public static String DEFAULT_HOUR = "2";
    public static String DLINE = "--";
    public static String CONST_REPLI_METHOD_FULL = "FullFCL";
    public static String CONST_REPLI_METHOD_SPLIT = "SplitFCL";
    public static String ERR_FLAG_FOR_FSorVol = "forFSorVol";
    public static String ERR_FLAG_FOR_MVDSync = "forMVDSync";
    
    public static String ERR_ORIGINAL_NOT_EXIST = "0x12400052";
}