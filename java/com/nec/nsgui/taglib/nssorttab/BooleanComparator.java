
/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: BooleanComparator.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 *
 */



package com.nec.nsgui.taglib.nssorttab;

import java.util.Comparator;

/**
 * @author  $Author: xingh $
 * @version $Revision: 1.1 $
 */

public class BooleanComparator implements Comparator {
	public int compare(Object o1, Object o2){
		if(o1==null && o2 == null) return 0;
		if(o1 == null) return -1;
		if(o2 == null) return 1;

		Boolean b1 = (Boolean) o1, b2 = (Boolean) o2;
		if (b1.equals(b2)) return 0;
		if (b1.equals(Boolean.FALSE)) return -1;
		return 1;
	}
	
}

