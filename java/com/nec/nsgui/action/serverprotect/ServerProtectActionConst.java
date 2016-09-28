/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.serverprotect;

public interface ServerProtectActionConst {
	public static final String cvsid = "@(#) $Id: ServerProtectActionConst.java,v 1.5 2007/03/30 07:41:21 wanghui Exp $";

	public static final String SCRIPT_GET_SERVICE_INTERFACES = "/bin/serverprotect_getServiceIpInfo.pl";

	public static final String SCRIPT_HAVE_CONFIG_FILE = "/bin/serverprotect_haveSettingFile.pl";

	public static final String SCRIPT_GET_GLOBAL_OPTION_INFO = "/bin/serverprotect_getRealTimeScanInfo.pl";

	public static final String SCRIPT_GET_LUDB_USERS = "/bin/serverprotect_getLudbUsers.pl";

	public static final String SCRIPT_GET_SCAN_SERVER_INFO = "/bin/serverprotect_getScanServerInfo.pl";

	public static final String SCRIPT_SET_SCAN_SERVER_INFO = "/bin/serverprotect_setScanServerInfo.pl";

	public static final String SCRIPT_DEL_CONFIG_FILE = "/bin/serverprotect_delConfFile.pl";

	public static final String SCRIPT_DEL_SCAN_SHARE = "/bin/serverprotect_delScanTarget.pl";

	public static final String SCRIPT_GET_SCAN_SHARE_FOR_ADD = "/bin/serverprotect_getScanTarget4Add.pl";

	public static final String SCRIPT_ADD_SCAN_SHARE = "/bin/serverprotect_addScanTargetInfo.pl";

	public static final String SCRIPT_MODIFY_SCAN_SHARE = "/bin/serverprotect_modifyScanTargetInfo.pl";

	public static final String SCRIPT_READ_CONFIG_FILE = "/bin/serverprotect_readFile.pl";

	public static final String SCRIPT_WRITE_CONFIG_FILE = "/bin/serverprotect_writeFile.pl";

	public static final String SCRIPT_GET_VIRUS_SCAN_MODE = "/bin/serverprotect_getVirusScanMode.pl";

	public static final String GET_SCAN_SERVER_FOR_LIST_SCRIPT = "/bin/serverprotect_getScanServer4List.pl";

	public static final String GET_SCAN_TARGET_FOR_LIST_SCRIPT = "/bin/serverprotect_getScanTarget4List.pl";
	
	public static final String GET_DAEMON_STATE = "/bin/serverprotect_getDaemonState.pl";
	
	public static final String DELETE_TEMP_FILE = "/bin/serverprotect_deleteTempFile.pl";

	public static final String CONST_LICENSE_KEY_SERVERPROTECT = "nvavs";

	public static final String CONST_LICENSE_KEY_CIFS = "cifs";

	public static final String CONST_SECURITY_MODE_ADS = "ADS";
	
	public static final String CONST_LICENSE_KEY = "licenseKey";

	public static final String CONST_SERVER_PROTECT_YES = "yes";

	public static final String CONST_SERVER_PROTECT_NO = "no";

	public static final String CONST_SCAN_SHARE_TYPE_REALTIME = "realtimescan";

	public static final String CONST_SCANSERVER_FORM_GLOBALOPTION = "globalOption";

	public static final String CONST_SCANSERVER_FORM_SCANSERVER = "scanServer";

	public static final String CONST_SCANSERVER_FORM_SCANUSERCHANGE = "scanUserChange";

	public static final String CONST_SCANSERVER_FORM_SCANSERVERCHANGE = "scanServerChange";

	public static final String CONST_SCANSHARE_FORM_SELECTEDSHARE = "selectedShare";

	public static final String CONST_SCANSHARE_CHANGE_FORM_READCHECK = "readCheck";

	public static final String CONST_SCANSHARE_CHANGE_FORM_WRITECHECK = "writeCheck";

	public static final String REQUEST_LUDB_USERS = "ludbUsers";
	
    public static final String REQUEST_HASCONFIGFILE = "hasConfigFile";

	public static final String SESSION_HASCONFIGFILE = "serveProtect_directEdit_hasConfigFile";

	public static final String REQUEST_NIC = "nic";

	public static final String REQUEST_NICLABEL = "nicLabel";

	public static final String REQUEST_SCAN_SHARE_LIST = "scanShareList";

	public static final String REQUEST_SCAN_SHARE_NAMES = "scanShareNames";

	public static final String REQUEST_SCAN_SHARE_NAMES_LABEL = "scanShareNamesLabel";

	public final static String REQUEST_NOWARNING = "serverprotect_noAlert";
	
	public final static String REQUEST_ERRORINFO = "serverProtectConfErrorInfo";

	public final static String REQUEST_DOFAILEDALERT = "serverProtectDoFailedAlert";

	public static final String SESSION_SERVERPROTECT_DOMAINNAME = "serverprotect_domainName";

	public static final String SESSION_SERVERPROTECT_COMPUTERNAME = "serverprotect_computerName";

	public static final String ERR_EXEC_NVAVS_CONFIG = "0x13600005";

	public static final String CLASS_GLOBAL_OPTION_BEAN = "com.nec.nsgui.model.entity.serverprotect.ServerProtectGlobalOptionBean";

	public static final String CLASS_SCAN_SERVER_BEAN = "com.nec.nsgui.model.entity.serverprotect.ServerProtectScanServerBean";

	public static final String CLASS_SCAN_TARGET_BEAN = "com.nec.nsgui.model.entity.serverprotect.ServerProtectScanTargetBean";

	public static final String MESSAGE_FOR_CONNECTSTATUS_CONNECT = "serverprotect.scanserver.connectstatus.td.connect";

	public static final String MESSAGE_FOR_CONNECTSTATUS_DISCONNECT = "serverprotect.scanserver.connectstatus.td.disconnect";

	public static final String MESSAGE_FOR_CONNECTSTATUS_ERROR = "serverprotect.scanserver.connectstatus.td.error";

}
