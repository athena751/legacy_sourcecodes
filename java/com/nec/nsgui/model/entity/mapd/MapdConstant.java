/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.mapd;

public interface MapdConstant{
    public static String cvsid="@(#) $Id:";
    public static final String SUDO_COMMAND = "sudo"; 
    public static final String SCRIPT_GET_DMOUNT_INFO = "/bin/userdb_getdmountlist.pl";
    public static final String SCRIPT_GET_DOMAIN_INFO = "/bin/userdb_getdomaininfo.pl";
    public static final String SCRIPT_AUTH = "/usr/bin/ims_auth";
    public static final String NOT_SET ="--";
    
    
    public static final String ISSUCCESS = "ISSUCCESS";
    public static final String DMP = "DMP_INFO";
    public static final String UNIX_AUTH = "UNIX_AUTH_INFO";
    public static final String WIN_AUTH = "WIN_AUTH_INFO";
    
    public static final String ONE_AUTH = "ONE_AUTH_INFO";
    public static final String DMOUNT_NAME = "DMOUNT_NAME";
    public static final String DMOUNT_FSTYPE = "DMOUNT_FSTYPE";
    public static final String DMOUNT_HAS_AUTH = "HAS_AUTH";
}
