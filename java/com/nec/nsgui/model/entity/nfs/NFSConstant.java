/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.nfs;

/**
 *
 */
public interface NFSConstant {
    public static final String cvsid = "@(#) $Id: NFSConstant.java,v 1.14 2009/04/23 02:09:43 yangxj Exp $";
    public static final String CONFIG_FILE_NAME = "/exports";
    public static final String SUDO_COMMAND = "sudo";
    public static final String ETC_GROUP = "/etc/group";
    public static final String SCRIPT_GET_CONFIG_FILE = "/bin/nfs_getConfigFileContent.pl";
    public static final String SCRIPT_SAVE_CONFIG_FILE = "/bin/nfs_saveConfigFile.pl";
    public static final String SCRIPT_CREATE_TEMP_FILE = "/bin/nfs_createTempFile.pl";
    public static final String GET_ENTRY_SCRIPT = "/bin/nfs_getentries.pl";
    public static final String DELETE_ENTRY_SCRIPT = "/bin/nfs_deleteentry.pl";
    public static final String GET_ALL_DETAIL_INFO_SCRIPT = "/bin/nfs_getAllDetailInfo.pl";
    public static final String MODIFY_EXPORT_INFO_SCRIPT = "/bin/nfs_modifyExportInfo.pl";

    public static final String NFS_DEFAULT_ACCESSLOG_FILE_PATH = "/var/opt/nec/nfsaccesslog/nfsaccesslog";
    public static final String NFS_ACCESSLOG_CONF_FILE_PATH = "/etc/sysconfig/nfsd/nfsaccesslog.conf";
    public static final String NFS_LOG_FILE_SIZE_KB = "k";
    public static final String NFS_LOG_FILE_SIZE_MB = "M";
    
    public static final String NFS_LOG_SET_EXCEPTION_SESSION = "NFS_LOG_SET_EXCEPTION_SESSION";
    public static final String NFS_ACCESSLOG_WIN = "nfs_log_set_access_win";
    public static final String NFS_VALID_FILE_NAME_CHAR = "!#$%&\\\'()+-./=@^_`~"; 
    
    public static final String GET_LOG_FILE_INFO_SCRIPT =
        "/bin/nfs_getLogFileInfo.pl";
    public static final String SAVE_LOG_INFO_SCRIPT =
        "/bin/nfs_saveLogOptionsToFile.pl";
    public static final String CHECK_LOG_FILE_PATH_SCRIPT =
        "/bin/nfs_checkFilePath.pl";
    public static final String GET_CLIENT_INFO_SCRIPT =
        "/bin/nfs_getClientInfo.pl"; 
    public static final String NSGUI_GET_VALUE_SCRIPT=
    	"/bin/nsgui_getvalue.pl";
    public static final String ACCESS_STATUS_CONF_FILE=
    	"/etc/sysconfig/nfsd/nfsd.conf";
    public static final String ACCESS_STATUS_KEY=
    	"fs.nfs.correct_access";
    public static final String SET_ACCESS_STATUS_SCRIPT=
    	"/bin/nfs_setAccessStatus.pl";
    public static final String ACCESS_STATUS=
    	"accessStatus";
    public static final String RPQ_NO_UNSTABLEWRITE = "0007";
    public static final String NFS_SESSION_RPQ_LICENSE_KEY = "NFS_SESSION_RPQ_LICENSE";
}
