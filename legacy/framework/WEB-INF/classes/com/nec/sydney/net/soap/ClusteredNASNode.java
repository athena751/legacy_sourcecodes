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

public class ClusteredNASNode {
	private static final String	cvsid = "@(#) $Id: ClusteredNASNode.java,v 1.2301 2004/07/19 08:10:38 baiwq Exp $";
	public static int 	howManySetupinfoDir(String addr) {
		String[] cmd = {"rsh",
				addr,
				"/home/nsadmin/bin/cluster_howManySetupinfoDir.sh"};
		try {
			Runtime rt = Runtime.getRuntime();
			NSProcess proc = new NSProcess(rt.exec(cmd));
			proc.waitFor();
			InputStreamReader isr = 
				new InputStreamReader(proc.getInputStream());
			BufferedReader  reader = new BufferedReader(isr);
			String	line = reader.readLine();
			NSReporter.getInstance().report(NSReporter.DEBUG,
				"howManySetupinfoDir: "+line);
			if (line != null)
				return Integer.parseInt(line);
			else 
				return 0;
		} catch (Exception ex) {
			NSReporter.getInstance().report(NSReporter.ERROR,
				"howManySetupinfoDir: "+ex.getMessage());
			return 0;
		}
	}
}
