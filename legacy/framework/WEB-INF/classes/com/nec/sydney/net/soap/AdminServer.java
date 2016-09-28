/*
 *      Copyright (c) 2002 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.net.soap;

import java.io.*;
import com.nec.sydney.framework.*;
import com.nec.nsgui.model.biz.base.NSProcess;

public class AdminServer {
	private static final String	cvsid = "@(#) $Id: AdminServer.java,v 1.2301 2004/07/19 08:10:38 baiwq Exp $";
	public static String 	getMyFriendIPAddress() {
		String[] cmd = {"sudo",
				"/home/nsadmin/bin/getMyFriend.sh"};
		try {
			Runtime rt = Runtime.getRuntime();
			NSProcess proc = new NSProcess(rt.exec(cmd));
			proc.waitFor();
			InputStreamReader isr = 
				new InputStreamReader(proc.getInputStream());
			BufferedReader  reader = new BufferedReader(isr);
			String	line = reader.readLine();
			if (line != null)
				return line;
			else 
				return null;
		} catch (Exception ex) {
			NSReporter.getInstance().report(NSReporter.ERROR,
				cmd[1]+": "+ex.getMessage());
			return null;
		}
	}
}
