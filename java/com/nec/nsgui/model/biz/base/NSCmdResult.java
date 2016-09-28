/*
 * Created on 2004-6-18
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
 
package com.nec.nsgui.model.biz.base;

/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
public class NSCmdResult {
	private static final String cvsid =
			"@(#) $Id: NSCmdResult.java,v 1.1 2004/07/02 13:34:38 changhs Exp $";
	private String[] stdout = {};
	private String[] stderr = {};
	private int 	exitValue=0;
    private String[]  cmds={};

	public String[] getCmds() {
		return cmds;
	}
	public int getExitValue() {
		return exitValue;
	}
	public String[] getStderr() {
		return stderr;
	}
	public String[] getStdout() {
		return stdout;
	}
	public void setCmds(String[] strings) {
		cmds = strings;
	}
	public void setExitValue(int i) {
		exitValue = i;
	}
	public void setStderr(String[] strings) {
		stderr = strings;
	}
	public void setStdout(String[] strings) {
		stdout = strings;
	}

}
