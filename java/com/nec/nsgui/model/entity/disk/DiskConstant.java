/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.disk;

public interface DiskConstant {
    public static final String cvsid =  "@(#) $Id: DiskConstant.java,v 1.4 2007/09/07 08:24:38 liq Exp $";
    public static final String SUDO_COMMAND = "sudo"; 
    
    public static final String SCRIPT_GET_UNUSED_PD_INFO = "/bin/disk_getNotUsedPD.pl";
    public static final String SCRIPT_GET_NEW_POOL_NUMBER = "/bin/disk_getNewPoolNumber.pl";
    public static final String SCRIPT_BIND_POOL = "/bin/disk_bindPool.pl";   
    
    public static final String SCRIPT_GET_RAID6_POOL_LIST = "/bin/disk_getRaid6List.pl";
    public static final String SCRIPT_GET_ONE_POOL_INFO = "/bin/disk_getOnePoolInfo.pl";
    public static final String SCRIPT_GET_ONE_POOL_PD = "/bin/disk_getOnePoolPD.pl";
    public static final String SCRIPT_EXPAND_POOL = "/bin/disk_expandPool.pl";
    
    public static final String SCRIPT_BIND_POOL_FORCAPACITY = "/bin/disk_bindPoolforcapacity.pl";
    public static final String SCRIPT_EXPAND_POOL_FORCAPACITY = "/bin/disk_expandPoolforcapacity.pl";
    
    public static final String SESSION_OLD_POOL_PD = "SESSION_DISK_OLD_POOL_PD";
    public static final String SESSION_RAID6_POOL_LIST = "SESSION_DISK_RAID6_POOL_LIST";
    public static final String SESSION_OLD_POOL_CAPACITY = "SESSION_DISK_OLD_POOL_CAPATICY";
    public static final String SESSION_SMALL_POOL_PD_CAPACITY = "SESSION_DISK_SMALL_POOL_PD_CAPATICY";
    
    public static final String SESSION_DISKARRAY_TYPE = "NVDiskArrayType";
    public static final String SCRIPT_GETDISKARRAYTYPE = "/bin/disk_getdiskarraytype.pl";
    public static final String SESSION_DISKARRAY_TYPE_S1500 = "S1500";
    public static final String SESSION_DISKARRAY_TYPE_S1400 = "S1400";
    public static final String SESSION_DISKARRAY_TYPE_D1 = "D1";
    public static final String SESSION_DISKARRAY_TYPE_D3 = "D3";

    
}
