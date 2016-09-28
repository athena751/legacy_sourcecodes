/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.atom.admin.cluster;
	
import	java.util.*;
import	com.nec.sydney.net.soap.*;

public class	SiriusInfo extends  SoapResponse {
	private static final String	cvsid = "@(#) $Id: SiriusInfo.java,v 1.2300 2003/11/24 00:54:32 nsadmin Exp $";
	public	SiriusInfo() {
		super();
		type = -1;
	}
	public void	setType(int t) {
		type = t;
	}
	public int	getType() {
		return type;
	}
	private	int	type;
}
