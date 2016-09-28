/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.service.admin;

import	java.io.*;
import	java.util.*;
import	com.nec.sydney.framework.*;
import	com.nec.sydney.net.soap.*;
import com.nec.nsgui.model.biz.base.NSProcess;

public class ClusterGroupSoapServer {
	private static final String	cvsid = "@(#) $Id: ClusterGroupSoapServer.java,v 1.2301 2004/07/19 08:10:39 baiwq Exp $";
	public	ClusterGroupSoapServer() {
		;
	}
	public ClusterGroupInfo	getClusterGroupAddr(int groupN) throws Exception {
		ClusterGroupInfo	info = new ClusterGroupInfo();
		try {
			String	cmd[] = {"sudo", chkcmd, Integer.toString(groupN)};
			Runtime	rt = Runtime.getRuntime();
			NSProcess proc = new NSProcess(rt.exec(cmd));
			proc.waitFor();
			InputStreamReader isr = 
				new InputStreamReader(proc.getInputStream());
			BufferedReader	reader = new BufferedReader(isr);
			Map	map = new HashMap();
			String	line;
			int	n = 0;
			while ((line = reader.readLine()) != null) {
				info.setAddress(line);
				++n;
			}
			if (n != 1) {
				info.setSuccessful(false);
				info.setErrorMessage(line);
			}
			return info;
		} catch (Exception ex) {
			info.setSuccessful(false);
			info.setErrorMessage(ex.getMessage());
			Map	map = new HashMap();
			return info;
		}
	}
	private static final String	chkcmd = "/home/nsadmin/bin/cluster_group_which_node.sh";
}
