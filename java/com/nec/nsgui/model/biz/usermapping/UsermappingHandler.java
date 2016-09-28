/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.usermapping;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;

public class UsermappingHandler {
    private static final String cvsid = "@(#) $Id: UsermappingHandler.java,v 1.2 2008/05/14 04:51:53 fengmh Exp $";

    private static final String SCRIPT_ISWORKING_COMPUTER = "/bin/cifs_isWorkingComputer.pl";
    private static final String SCRIPT_CHECK_COMPUTERNAME = "/bin/schedulescan_checkComputerName.pl";
    private static final String SCRIPT_GET_ALLDOMANDCOM_SCHEDULESCAN = 
    	                                  "/bin/schedulescan_getAllDomAndCom.pl";
    private static final String SCRIPT_CHANGENETBIOS = "/bin/usermapping_changeNetbios.pl";
	
	public static boolean checkAccess(int groupNo, String domainName, 
			String computerName) throws Exception {
		String[] cmds = {CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_ISWORKING_COMPUTER,
				Integer.toString(groupNo),
				domainName,
				computerName
		};
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, groupNo);
		return cmdResult.getStdout()[0].equalsIgnoreCase("true");
	}
	
	public static boolean checkComputerName(int groupNo, 
			String computerName) throws Exception {
		String[] cmds = {CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_CHECK_COMPUTERNAME,
				Integer.toString(groupNo),
				computerName
		};
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, groupNo);
		return cmdResult.getStdout()[0].equalsIgnoreCase("exist");
	}
	
	public static String[] getAllDomAndComOfSchedulescan(int groupNo) throws Exception {
		String[] cmds = {CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_ALLDOMANDCOM_SCHEDULESCAN,
				Integer.toString(groupNo)
		};
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, groupNo);
		return cmdResult.getStdout();
	}
	
	public static void changeNetbios(int groupNo, String domainName, String newComputerName,
			String oldComputerName, boolean isFriend) throws Exception {
		String[] cmds = {CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_CHANGENETBIOS,
				Integer.toString(groupNo),
				domainName,
				newComputerName,
				oldComputerName,
				Boolean.toString(isFriend)
		};
		CmdExecBase.execCmd(cmds, groupNo);
	}
}
