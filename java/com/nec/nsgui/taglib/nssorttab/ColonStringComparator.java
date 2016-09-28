
/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: ColonStringComparator.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 *
 */



package com.nec.nsgui.taglib.nssorttab;

import java.util.Comparator;

/**
  * @author  $Author: xingh $
 * @version $Revision: 1.1 $
 */

public class ColonStringComparator implements Comparator {
	public int compare(Object o1, Object o2){
		if(o1 == null && o2 == null) return 0;
		if(o1 == null) return -1;
		if(o2 == null) return 1;

		String[] str1 = ((String) o1).split(":");
		String[] str2 = ((String)o2).split(":");

		Integer int10 = new Integer(str1[0]);
		Integer int11  =  new Integer(str1[1]);
		Integer int20 = new Integer(str2[0]);
		Integer int21  =  new Integer(str2[1]);
		if (int10.compareTo(int20) > 0) return 1;
		if(int10.compareTo(int20)<0) return -1;
		return int11.compareTo(int21);

	}
	
}

