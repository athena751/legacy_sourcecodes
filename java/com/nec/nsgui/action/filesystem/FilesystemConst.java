/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.filesystem;

public interface FilesystemConst {
	public static final String cvsid =
		"@(#) $Id: FilesystemConst.java,v 1.7 2008/04/19 12:00:57 jiangfx Exp $";
   
    public final static String  SESSION_FS_TABLE_MODE = "SESSION_FS_TABLE_MODE"; 
    public final static String  SESSION_FREE_LV_VEC = "SESSION_FREE_LV_VEC";

    // add by jiangfx
    public final static String SESSION_FREELD_TABLE_MODEL  = "FREELD_TABLE_MODEL";
    public final static String SESSION_FS_INFO_OBJ         = "FS_INFO_OBJ";
    // pair is set 
    public final static String ERR_IS_PAIRED     = "0x12400094";
    public final static String SESSION_IS_PAIRED = "hasPair";
    
    public final static String ERR_CODE_HAS_MOUNTED        = "0x13200030";
    //add for utf8 and utf-nfc
    public final static String ERR_CODE_CODEPAGE_UTF8      = "0x13200024";
    public final static String ERR_CODE_CODEPAGE_UTF8_4Mac = "0x13200026";

    public final static String SESSION_NV_ASYNC = "NV_ASYNC";
    public final static String SESSION_CURRENT_EXPORTGROUP_ASYNC = "CURRENT_EXPORTGROUP_ASYNC";
    public final static String SESSION_ASYNC_ERROR = "ASYNC_ERROR";
    public final static String PREFIX_REPLICA_ERROR = "0x124";
    public final static String ASYNC_NO_ERROR = "0x00000000";
    public final static String SESSION_WP_LICENSE = "FILESYSTEM_WRITE_PROTECTED_LICENSE";
}