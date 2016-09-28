/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.net.soap;
	
import	com.nec.sydney.net.soap.*;

public class	ClusterGroupInfo extends  SoapResponse {
	private static final String	cvsid = "@(#) $Id: ClusterGroupInfo.java,v 1.2300 2003/11/24 00:54:34 nsadmin Exp $";
	public	ClusterGroupInfo() {
		super();
	}
	public void	setAddress(String addr) {
		address = addr;
	}
	public String	getAddress() {
		return address;
	}
	private	String	address;
}
