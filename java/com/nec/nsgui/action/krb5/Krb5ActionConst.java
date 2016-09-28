/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.krb5;

public interface Krb5ActionConst {
    public static final String cvsid = "@(#) $Id: Krb5ActionConst.java,v 1.1 2006/11/06 06:11:45 liy Exp $";
    
    public static String SESSION_NOWARNING       = "krb5_noAlert";
    public static String SESSION_SYNC_WRITE_FLAG = "krb5_sync_write_flag";
    public static String SESSION_IS_CLUSTER      = "isCluster";
    
    public static String CONST_ERR_KRB5_DIFF_4NSADMIN = "0x13500001";
    public static String CONST_ERR_KRB5_DIFF_4NSVIEW  = "0x13500011";
    
    public static String CONST_ERR_FILE_SYNC     = "0x13500002";
    
}