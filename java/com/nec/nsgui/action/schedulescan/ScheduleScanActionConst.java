/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.schedulescan;

public interface ScheduleScanActionConst {
	public static final String cvsid = "@(#) $Id: ScheduleScanActionConst.java,v 1.3 2008/05/29 04:44:38 chenjc Exp $";

	public static final String SCRIPT_SET_GLOBAL_INFO = "/bin/schedulescan_setGlobalInfo.pl";

	public static final String SCRIPT_SET_COMPUTER_INFO = "/bin/schedulescan_setComputerInfo.pl";

	public static final String SCRIPT_SET_NEWCOMPUTER_INFO = "/bin/schedulescan_setNewComputerInfo.pl";

	public static final String SCRIPT_CHECK_USER_MAPPING = "/bin/schedulescan_checkUserMapping.pl";

	public static final String SCRIPT_CHECK_VS_SMB_PAIR = "/bin/schedulescan_judgeVSSmbPair.pl";

	public static final String SCRIPT_CHECK_COMPUTER_ACCESS = "/bin/cifs_isWorkingComputer.pl";

	public static final String SCRIPT_GET_ALL_INTERFACES = "/bin/schedulescan_getAllInterfaces.pl";

	public static final String SCRIPT_GET_SETTING_INFO = "/bin/schedulescan_getSettingInfo.pl";

	public static final String SCRIPT_GET_SCAN_SHARE_SCRIPT_FOR_LIST = "/bin/schedulescan_getScanShare4List.pl";

	public static final String SCRIPT_DEL_CONFIG_FILE = "/bin/schedulescan_delConfigFile.pl";

	public static final String SCRIPT_GET_VIRTUAL_COMPUTER_NAME = "/bin/schedulescan_getVirtualComputerName.pl";

	public static final String SCRIPT_HAVE_SET_GLOBAL = "/bin/schedulescan_haveSetGlobal.pl";

	public static final String SCRIPT_GET_SHARE_INFO = "/bin/schedulescan_getShareInfo.pl";

	public static final String SCRIPT_SET_SHARE_INFO = "/bin/schedulescan_setShareInfo.pl";

	public static final String CONST_FORM_COMPUTER_NAME = "computerName";

	public static final String CONST_FORM_GLOBAL_BEAN = "globalBean";

	public static final String CONST_FORM_OLD_COMPUTER_NAME = "oldComputerName";

	public static final String CONST_FORM_SHOULD_RESTART = "shouldRestart";

	public static final String CONST_REQUEST_HOST_NAME = "hostName";

	public static final String CONST_REQUEST_ALL_INTERFACES = "allInterfaces";

	public static final String CONST_REQUEST_ALL_INTERFACES_LABEL = "allInterfacesLabel";

	public static final String CONST_REQUEST_ALL_USERS = "allUsers";

	public static final String CONST_REQUEST_SHARES_UNUSED = "schedulescan_shareUnused";

	public static final String CONST_REQUEST_SHARES_USED = "schedulescan_shareUsed";

	public static final String CONST_REQUEST_HAVE_CONNECTION = "schedulescan_haveConnection";

	public static final String CONST_REQUEST_TO_ADD_USER = "toAddUser";

	public static final String CONST_SCHEDULESCAN_ADS = "ADS";

	public static final String CONST_SCHEDULESCAN_TARGET = "target";

	public static final String CONST_SCHEDULESCAN_YES = "yes";

	public static final String CONST_SCHEDULESCAN_NO = "no";

	public static final String SESSION_SCHEDULESCAN_DOMAINNAME = "schedulescan_domainName";

	public static final String SESSION_SCHEDULESCAN_COMPUTERNAME = "schedulescan_computerName";

	public static final String SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME = "schedulescan_virtualComputerName";

	public static final String SESSION_SCHEDULESCAN_HAVE_CONNECTION = "schedulescan_haveConnection";

	public static final String ERRCODE_GET_INFO = "0x14000001";

	public static final String ERRCODE_SET_INFO = "0x14000002";

	public static final String ERRCODE_DELETE_INFO = "0x14000003";

	public static final String ERRCODE_CHECK_INFO = "0x14000004";

	public static final String ERRCODE_SCHEDULESCAN_COMPUTER_EXIST = "0x14000005";

	public static final String ERRCODE_SCHEDULESCAN_USER_NOT_ADS = "0x14000006";

	public static final String ERRCODE_SCHEDULESCAN_USER_NOT_PWD = "0x14000007";

	public static final String ERRCODE_SCHEDULESCAN_USER_COMPUTER_EXIST = "0x14000008";

	public static final String ERRCODE_SCHEDULESCAN_NO_AVAILABLE_INTERFACE = "0x14000009";

	public static final String ERRCODE_SCHEDULESCAN_VS_SMB_PAIR = "0x1400000A";

	public static final String CLASS_SCAN_SHARE_BEAN = "com.nec.nsgui.model.entity.schedulescan.ScheduleScanShareBean";

	public static final String CLASS_GLOBAL_SET_BEAN = "com.nec.nsgui.model.entity.schedulescan.ScheduleScanGlobalBean";

}
