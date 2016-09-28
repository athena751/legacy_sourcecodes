
/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: CapacityComparator.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 *
 */



package com.nec.nsgui.taglib.nssorttab;

import java.util.Comparator;

/**
 * @author  $Author: xingh $
 * @version $Revision: 1.1 $
 */

public class CapacityComparator implements Comparator {
	public int compare(Object o1, Object o2){
		if(o1 == null && o2 == null) return 0;
		if(o1 == null) return -1;
		if(o2 == null) return 1;
		String str1 = (String)o1;
		String str2 = (String)o2;
		Double value1 = getDouble(str1.replaceAll(",",""));
		Double value2 = getDouble(str2.replaceAll(",",""));
		return value1.compareTo(value2);
	}

	private Double getDouble(String str){
		int idx = 0;

		String upperstr = str.toUpperCase();
		idx = upperstr.indexOf("G");
		if (idx >=0 ){
			return new Double(Double.parseDouble(upperstr.substring( 0 , idx)) * 1024 * 1024 * 1024);
		}

		idx = upperstr.indexOf("M");		
		if ( idx >=0 )	{
			return new Double(Double.parseDouble(upperstr.substring( 0 , idx)) * 1024 * 1024);
		}

		idx = upperstr.indexOf("K");
		if ( idx >=0 ) {
			return new Double(Double.parseDouble(upperstr.substring( 0 , idx)) * 1024 );
		}

		return new Double(str);

	}

	
}

