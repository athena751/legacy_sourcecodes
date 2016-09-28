/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

/**
 *
 */
public interface CifsActionConst {
    public static final String cvsid =
        "@(#) $Id: CifsActionConst.java,v 1.19 2008/12/18 08:04:06 chenbc Exp $";
    public final static String SESSION_DOMAIN_NAME =
        "cifs_domainName";
    public final static String SESSION_COMPUTER_NAME =
        "cifs_computerName";
    public final static String SESSION_EXPORT_GROUP_ENCODING =
        "cifs_expGrpEncoding";
    public final static String SESSION_ACTION_FOR_SHARE_OPTION =
        "cifs_shareOptionAction";
    public final static String SESSION_SECURITY_MODE =
        "cifs_securityMode";
    public final static String SESSION_GLOBAL_LOGITEM_MAP =
        "cifs_globalLogItemMap";
    public final static String SESSION_NIC_LIST =
        "cifs_nicList";
    public final static String SESSION_NICLABEL_LIST =
        "cifs_nicLabelList";
    public final static String SESSION_MOUNT_POINT_FOR_SNAP_SCHEDULE =
        "cifs_mountPointForSnapSchedule";
    public final static String ERROR_CODE_CORRESPONDING_VOLUME_USING_DMAPI =
        "0x10200011";
    public final static String ERROR_CODE_SET_DIR_ACCESS_FOR_SXFSFW =
        "0x10200015";
	public final static String ERROR_CODE_SET_GLOBALOPTION =
		"0x10200020";
    
    public final static String SESSION_SHARE_NAME = "cifs_shareName";
    public final static String SESSION_SHARED_DIRECTORY = "cifs_sharedDirectory";
	public final static String SESSION_TARGAET_FILETYPE ="cifs_targetFile";
	public final static String SESSION_IS_SET_GLOBAL_DIRACCESS ="setGlobal_alert";
	public final static String CANNOT_GET_DETAIL = "cannot_get_detail";
	public final static String SESSION_NEED_WARNING = "notNeedWarning";
	public final static String SESSION_ALERT_DMAPI_OPTION = "alertForDMAPI";
	public final static String SESSION_ALERT_DIRACCESS_FORSXFSFW = "alert_setDirAccessFor_sxfsfw";
	public final static String SESSION_ALERT_FOR_SHADOWCOPY  = "shadowCopy_alert";
	public final static String SESSION_ALERT_FOR_SNAPSHOT  = "need_snapshot_confirm";
	public final static String SESSION_SHARE_NAME_FOR_MODIFY = "shareNameForModify";
	public final static	String SESSION_SET_DIR_OPERATION = "setDirAction";
	public final static	String SESSION_SET_DIR_INFO = "setDirInfo";
    public final static String SECURITYMODE_ADS = "ADS";
    public final static String NAS_DC_LOG = "nas_dc_log";
    public final static String SESSION_LOGVIEW_SPLITFILES  = "dclog_logview_splitfiles";
    public final static String SESSION_LOGVIEW_SEARCHCONDTION  = "dclog_logview_searchcondition";
    public final static String SESSION_LOGVIEW_FILENAME = "dclog_tmplogFileName";
    public final static String SESSION_PASSWDSERVER = "cifs_passwd_server";
    public final static String REQUEST_CIFS_GET_DCCONNECTIONSTATUS_FAILD = "cifs_get_DCConnectionStatus_faild";
    public final static String ERRCODE_CIFS_GET_DCCONNECTIONSTATUS_NULL = "0x10200021";
    public final static String ERRCODE_CIFS_GET_DCCONNECTIONSTATUS_OPTIONERR = "0x10200022";
    public final static String ERRCODE_CIFS_GET_DCCONNECTIONSTATUS_TIMEOUT = "0x10200023";
    public final static String REQUEST_CIFS_SYSDATE = "cifs_sysDate";
    public final static String REQUEST_LOGVIEW_ERRORTYPE = "logview_errorType";
    public final static String REQUEST_DISABLE_DIRECTHOSTING = "disable_directHosting";
    public final static String SESSION_HASANTIVIRUSSCAN_LICENSE = "hasAntiVirusScanLicense";
    public final static String SESSION_SPECIALSHARE_MP = "specialshare_mp";
    public final static String SESSION_AVAILABLEDIRFORSCAN = "availableDirForScan";
    public final static String SESSION_AVAILABLEDIRFORSCAN_OPTION_VALUES = "availableDirForScanOptionValues";
    public final static String SESSION_ALLBACKUPUSER = "allBackupUser";
    
    public final static String CONST_NO_SERVICE_NETWORK = "No service network";
    public final static String CONST_NO_REMAINING_INTERFACE = "No remaining interface";
    
    public final static String ERRCODE_CIFS_DIRMAKE_DIR_EXISTS    = "0x10200031";
    public final static String ERRCODE_CIFS_DIRMAKE_MK_FAILED     = "0x10200032";
    public final static String ERRCODE_CIFS_DIRMAKE_MKDIR_ERROR   = "0x10200033";
    public final static String ERRCODE_CIFS_DIRMAKE_DIR_TOOLONG   = "0x10200034";
    public final static String ERRCODE_CIFS_DIRMAKE_CHOWN_ERROR   = "0x10200035";
    public final static String ERRCODE_CIFS_DIRDEL_NOT_EMPTY      = "0x10200036";
    public final static String ERRCODE_CIFS_DIRDEL_IN_CIFS_SHARE  = "0x10200037";
    public final static String ERRCODE_CIFS_DIRDEL_IN_NFS_SHARE   = "0x10200038";
    public final static String ERRCODE_CIFS_DIRDEL_DIR_ACCESS_CTR = "0x10200039";
    public final static String ERRCODE_CIFS_DIRDEL_READONLY_FS    = "0x1020003A";
    public final static String ERRCODE_CIFS_DIRDEL_UNDER_NV_RESV  = "0x1020003B";
    public final static String ERRCODE_CIFS_DIRDEL_MOUNT_POINT    = "0x1020003C";
    public final static String ERRCODE_CIFS_DIRDEL_DIR_NOT_EXIST  = "0x1020003D";
    public final static String ERRCODE_CIFS_DIRMAKE_WRONG_ACL_ENC = "0x1020003E";
    public final static String ERRCODE_CIFS_DIRMAKE_FULL_PATH_OVER4095 = "0x1020003F";
    
    public final static String TRACE_MESSAGE_MKDIR_ERROR  = "Failed to make directory while executing /bin/mkdir. There is the possibility of the directory quota limit or the shortage of the volume capacity.";
    public final static String TRACE_MESSAGE_CHOWN_ERROR  = "Failed to change the directory owner while executing /bin/chown. There is the possibility of the quota limit.";
    
    public final static String SESSION_COMMENT_TOOLONG_BY_EXPORTENCODING   = "cifs_commentTooLong"; 
    public final static String SESSION_DIRECTORY_TOOLONG_BY_EXPORTENCODING = "cifs_directoryTooLong";
    public final static String ERRCODE_STRING_TOOLONG_BY_EXPORTENCODING    = "0x10200040";
    public final static String ERRCODE_DIRECTORY_OVER240_BY_UTF8_NFC       = "0x10200041";
    public final static String ERRCODE_DIRECTORY_OVER144_BY_UTF8_NFC       = "0x10200042";
}
