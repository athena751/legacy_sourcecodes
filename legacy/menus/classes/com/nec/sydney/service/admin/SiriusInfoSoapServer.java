/*
 *      Copyright (c) 2002 NEC Corporation
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
import	com.nec.sydney.atom.admin.cluster.*;
import com.nec.nsgui.model.biz.base.NSProcess;

public class SiriusInfoSoapServer {
	private static final String	cvsid = "@(#) $Id: SiriusInfoSoapServer.java,v 1.2301 2004/07/19 08:10:39 baiwq Exp $";
	public	SiriusInfoSoapServer() {
		;
	}
	public SiriusInfo	getSiriusInfo() throws Exception {
		SiriusInfo	info = new SiriusInfo();
		try {
			String	cmd[] = {"sudo", chkcmd};
			Runtime	rt = Runtime.getRuntime();
			NSProcess proc = new NSProcess (rt.exec(cmd));
			proc.waitFor();
			info.setSuccessful(true);
			info.setType(proc.exitValue());
			return info;
		} catch (Exception ex) {
			info.setSuccessful(false);
			info.setErrorMessage(ex.getMessage());
			Map	map = new HashMap();
			info.setType(-1);
			return info;
		}
	}
	private static final String	chkcmd = "/home/nsadmin/bin/getMachineType.sh";
}
