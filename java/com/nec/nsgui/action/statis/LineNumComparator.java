/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.Comparator;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class LineNumComparator implements Comparator {
    public static final String cvsid 
            = "@(#) $Id: LineNumComparator.java,v 1.1 2005/10/18 16:24:27 het Exp $";    
	public int compare(Object o1, Object o2) {
		if (o1 == null && o2 == null)
			return 0;
		if (o1 == null)
			return -1;
		if (o2 == null)
			return 1;

		String str1 = (String) o1;
		String str2 = (String) o2;
		if (o1.equals("--") && o2.equals("--")) {
			return 0;
		}
		if (o1.equals("--")) {
			return -1;
		}
		if (o2.equals("--")) {
			return 1;
		}
		Double dou1 = new Double(str1);
		Double dou2 = new Double(str2);
		return dou1.compareTo(dou2);
	}
}
