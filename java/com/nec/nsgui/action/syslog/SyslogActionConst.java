/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.syslog;

import com.nec.nsgui.model.entity.syslog.SyslogBeanConst;

/**
 *
 */
public interface SyslogActionConst extends SyslogBeanConst{
    public static final String cvsid =
        "@(#) $Id: SyslogActionConst.java,v 1.6 2008/05/09 05:01:39 hetao Exp $";
    public final static String SYSTEM_LOG_FILE_NAME = "/var/log/messages";
    public final static String NFS_PERFORM_LOG_FILE_NAME  = "nfs_perform_log";
    public final static String NFS_ACCESS_LOG_FILE_NAME  = "nfs_access_log";
    
    public final static String HTTP_LOG_NAME_ACCESS = "/var/log/httpd/access_log";
    public final static String HTTP_LOG_NAME_ERROR  = "/var/log/httpd/error_log";
    
    public final static String H1_KEY_SYSTEM_LOG    = "syslog.system.h1";
    public final static String H1_KEY_HTTP_LOG      = "syslog.http.h1";
    public final static String H1_KEY_FTP_LOG       = "syslog.ftp.h1";
    public final static String H1_KEY_CIFS_LOG      = "syslog.cifs.h1";
    public final static String H1_KEY_NFS_LOG       = "syslog.nfs.h1";

    public final static String SESSION_NAME_H1_KEY  = "syslog_h1_key";
    public final static String SESSION_NAME_NFS_PERFORM_SEARCH_ENDED = "syslog_nfsPerformSearchEnded";
    public final static String SESSION_NAME_NFS_PERFORM_LOG_FILE = "syslog_nfsPerformLogFile";

    public final static String SESSION_LOGVIEW_SEARCHCONDTION  = "syslog_logview_searchcondition";
    public final static String SESSION_LOGVIEW_SPLITFILES  = "syslog_logview_splitfiles";
    public final static String SESSION_LOGVIEW_FILENAME = "logview_fileName";
    public final static String REQUEST_LOGVIEW_ERRORTYPE = "logview_errorType";
    
    public final static String LICENSE_KEY_HTTP = "http";
    public final static String LICENSE_KEY_FTP  = "ftp";
    public final static String LICENSE_KEY_CIFS = "cifs";
    public final static String LICENSE_KEY_NFS  = "nfs";

    public final static String NFS_PERFORM_SEARCH_ENDED = "nfsPerformSearchHasEnded";
    
    public final static String SESSION_NAME_DIRECTDOWNLOAD_MAKEFILE_ENDED = "syslog_directdownload_makefile";
    public final static String DIRECTDOWN_MAKEFILE_ENDED = "directDownloadMakefileEnded";
    
}
