/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.syslog;

/**
 *
 */
public interface SyslogBeanConst {

    public static final String cvsid =
        "@(#) $Id: SyslogBeanConst.java,v 1.2 2008/05/09 05:02:51 hetao Exp $";

    public final static String LOG_TYPE_SYSTEM_LOG  = "systemLog";
    public final static String LOG_TYPE_HTTP_LOG    = "httpLog";
    public final static String LOG_TYPE_FTP_LOG     = "ftpLog";
    public final static String LOG_TYPE_CIFS_LOG    = "cifsLog";
    public final static String LOG_TYPE_NFS_LOG     = "nfsLog";
    
    public final static String SEARCCH_ACTION_DISPLAY_ALL = "displayAll";
    public final static String SEARCCH_ACTION_SEARCH_RESULT_DISPLAY = "searchResultDisplay";
    
    public final static String LOG_TEMP_DIR = "/var/crash/.nsguiwork/logview/";

}
