/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.schedulescan;

import java.util.List;

import com.nec.nsgui.action.schedulescan.ScheduleScanActionConst;
import com.nec.nsgui.action.serverprotect.ServerProtectActionConst;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.entity.schedulescan.ScheduleScanGlobalBean;

public class ScheduleScanHandler implements ScheduleScanActionConst {
	public static final String cvsid = "@(#) $Id: ScheduleScanHandler.java,v 1.3 2008/05/29 04:46:36 chenjc Exp $";

	/**
	 * 
	 * @param nodeNo
	 *            the current node number
	 * @param domainName
	 *            domain name
	 * @return -Schedule Scan Global Info
	 * @throws Exception
	 * @author hanhui
	 */

	public static ScheduleScanGlobalBean getGlobalInfo(int nodeNo,
			String domainName, String computerName) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_SETTING_INFO,
				Integer.toString(nodeNo), domainName, computerName };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo, true, true);
		ScheduleScanGlobalBean globalInfo = new ScheduleScanGlobalBean();
		NSBeanUtil.setProperties(globalInfo, cmdResult.getStdout());
		return globalInfo;
	}

	/**
	 * 
	 * @param nodeNumber -
	 *            the current node number
	 * @param computerName -
	 *            virtual computer name
	 * @param domainName
	 *            domain name
	 * @return - Scan Target Info
	 * @throws Exception
	 * @author hanhui
	 * 
	 */

	public static List getScanShareList(int nodeNumber, String domainName,
			String computerName) throws Exception {
		String[] cmds = {
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home")
						+ SCRIPT_GET_SCAN_SHARE_SCRIPT_FOR_LIST,
				Integer.toString(nodeNumber), domainName, computerName };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber, true,
				true);
		String results[] = cmdResult.getStdout();
		return NSBeanUtil.createBeanList(CLASS_SCAN_SHARE_BEAN, results, 2);
	}

	/**
	 * Get the virtual computer name
	 * 
	 * @param nodeNo
	 * @param exportGroup
	 * @param domainName
	 * @throws Exception
	 * @return virtualComputerName
	 * @author hanhui
	 */

	public static String getVirtualComputerName(int nodeNo,
			String exportGroupName, String domainName) throws Exception {

		String[] cmds = {
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home")
						+ SCRIPT_GET_VIRTUAL_COMPUTER_NAME,
				Integer.toString(nodeNo), exportGroupName, domainName };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo, true, true);
		if (cmdResult.getStdout().length >= 1) {
			return cmdResult.getStdout()[0];
		} else {
			return "";
		}
	}

	/**
	 * Delete the config file
	 * 
	 * @param nodeNumber
	 * @param computerName
	 * @param domainName
	 * @throws Exception
	 * @return void
	 * @author hanhui
	 */

	public static void deleteConfigFile(int nodeNumber, String exportGroupName,
			String domainName, String computerName) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_DEL_CONFIG_FILE,
				Integer.toString(nodeNumber), exportGroupName, domainName,
				computerName };
		CmdExecBase.execCmd(cmds, nodeNumber, true, true);
	}

	/**
	 * 
	 * @param groupNo
	 * @param domainName
	 * @param computerName
	 * @return
	 * @throws Exception
	 */
	public static String haveSmbConnection(int groupNo, String domainName,
			String computerName) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_CHECK_COMPUTER_ACCESS,
				Integer.toString(groupNo), domainName, computerName };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, groupNo, true, true);
		String result = cmdResult.getStdout()[0];
		if (result.equals("true")) {
			return CONST_SCHEDULESCAN_YES;
		}
		return CONST_SCHEDULESCAN_NO;
	}

	/**
	 * 
	 * @param nodeNo
	 * @param domainName
	 * @param vComputerName
	 * @return
	 * @throws Exception
	 */
	public static String[] getAllInterfaces(int nodeNo, String domainName,
			String vComputerName) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_ALL_INTERFACES,
				String.valueOf(nodeNo), domainName, vComputerName };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo, true, true);
		return cmdResult.getStdout();
	}

	/**
	 * 
	 * @param nodeNo
	 * @param domainName
	 * @param computerName
	 * @return
	 * @throws Exception
	 */
	public static String[] getAllUsers(int nodeNo, String domainName,
			String vComputerName) throws Exception {
		/*
		 * use script "/bin/serverprotect_getLudbUsers.pl" to get the
		 * "realtimescan" type users
		 */
		String userTpye = ServerProtectActionConst.CONST_SCAN_SHARE_TYPE_REALTIME;
		String[] cmds = {
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home")
						+ ServerProtectActionConst.SCRIPT_GET_LUDB_USERS,
				String.valueOf(nodeNo), domainName, vComputerName, userTpye };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo, true, true);
		return cmdResult.getStdout();
	}

	/**
	 * 
	 * @param nodeNo
	 * @param exportPath
	 * @param domainName
	 * @param oldVComputerName
	 * @param vComputerName
	 * @throws Exception
	 */
	public static void setComputerInfo(int nodeNo, String exportPath,
			String domainName, String oldVComputerName, String vComputerName)
			throws Exception {

		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_SET_COMPUTER_INFO,
				String.valueOf(nodeNo), exportPath, domainName,
				oldVComputerName, vComputerName };
		CmdExecBase.execCmd(cmds, nodeNo);
	}

	/**
	 * 
	 * @param nodeNo
	 * @param exportPath
	 * @param domainName
	 * @param computerName
	 * @param vComputerName
	 * @throws Exception
	 */
	public static void setNewComputerInfo(int nodeNo, String exportPath,
			String domainName, String computerName, String vComputerName)
			throws Exception {

		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_SET_NEWCOMPUTER_INFO,
				String.valueOf(nodeNo), exportPath, domainName, computerName,
				vComputerName };
		CmdExecBase.execCmd(cmds, nodeNo);
	}

	/**
	 * check vs and smb file are in pair or not
	 * 
	 * @param nodeNo
	 * @throws Exception
	 */
	public static String checkVSSmbPair(int nodeNo) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_CHECK_VS_SMB_PAIR,
				String.valueOf(nodeNo) };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
		return cmdResult.getStdout()[0];
	}

	/**
	 * check whether there is user database for the computer
	 * 
	 * @param nodeNo
	 * @param domainName
	 * @param oldVComputerName
	 * @param vComputerName
	 * @return
	 * @throws Exception
	 */
	public static String[] haveUserMapping(int nodeNo, String domainName,
			String oldVComputerName, String vComputerName) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_CHECK_USER_MAPPING,
				String.valueOf(nodeNo), domainName, oldVComputerName,
				vComputerName };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
		return cmdResult.getStdout();
	}

	/**
	 * 
	 * @param nodeNo
	 * @param domain
	 * @param computerName
	 * @param virtualComputerName
	 * @param scanServer
	 * @param selectedInterfaces
	 * @param selectedUsers
	 * @param shouldRestart
	 * @throws Exception
	 */
	public static void setGlobalInfo(int nodeNo, String domainName,
			String computerName, String vComputerName,
			String selectedInterfaces, String selectedUsers, String scanServer,
			String shouldRestart) throws Exception {

		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_SET_GLOBAL_INFO,
				String.valueOf(nodeNo), domainName, computerName,
				vComputerName, selectedInterfaces, selectedUsers, scanServer,
				shouldRestart };
		CmdExecBase.execCmd(cmds, nodeNo, true, true);
	}

	/**
	 * Judge whether schedule scan config file exists
	 * 
	 * @param nodeNum
	 * @param domainName
	 * @param sComputer:
	 *            computer name for shedule scan
	 * @return
	 * @throws Exception
	 */
	public static String haveSetGlobal(int nodeNum, String domainName,
			String sComputer) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_HAVE_SET_GLOBAL,
				Integer.toString(nodeNum), domainName, sComputer };

		NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNum, true, true);
		return result.getStdout()[0];
	}

	/**
	 * 
	 * @param nodeNum
	 * @param domainName
	 * @param vsComputer
	 * @param sComputer
	 * @return
	 * @throws Exception
	 */
	public static String[] getShareInfo(int nodeNum, String domainName,
			String vsComputer, String sComputer) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_SHARE_INFO,
				Integer.toString(nodeNum), domainName, vsComputer, sComputer };

		NSCmdResult result = CmdExecBase.execCmd(cmds, nodeNum, true, true);
		return result.getStdout();

	}

	/**
	 * 
	 * @param nodeNum
	 * @param domainName
	 * @param vsComputer
	 * @param sComputer
	 * @param shares
	 * @throws Exception
	 */
	public static void setShareInfo(int nodeNum, String domainName,
			String vsComputer, String sComputer, String shares)
			throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_SET_SHARE_INFO,
				Integer.toString(nodeNum), domainName, vsComputer, sComputer,
				shares };

		CmdExecBase.execCmd(cmds, nodeNum, true, true);
	}

}
