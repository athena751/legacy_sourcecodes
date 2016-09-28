/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.domain;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;

public class DomainHandler {
	private static final String cvsid = "@(#) $Id: DomainHandler.java,v 1.1 2007/04/16 05:39:26 wanghb Exp $";

	private static final String SCRIPT_GET_HOST_NAME = "/bin/userdb_getHostName.pl";

	public static String[] getHostName(int nodeNumber) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_HOST_NAME };
		NSCmdResult cmdResult = CmdExecBase.execCmdInMaintain(cmds, nodeNumber,
				true);
		return cmdResult.getStdout();
	}
}
