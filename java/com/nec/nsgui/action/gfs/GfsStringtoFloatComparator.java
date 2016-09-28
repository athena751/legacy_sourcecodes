/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: GfsStringtoFloatComparator.java,v 1.1 2005/11/04 01:25:07 zhangj Exp $
 */

package com.nec.nsgui.action.gfs;

import java.util.Comparator;

public class GfsStringtoFloatComparator implements Comparator {
    public int compare(Object o1, Object o2){
        if(o1 == null && o2 == null) return 0;
        if(o1 == null) return -1;
        if(o2 == null) return 1;
        try {
            Float valueO1 = Float.valueOf((String)o1);
            Float valueO2 = Float.valueOf((String)o2);
            return valueO1.compareTo(valueO2);
        } catch (NumberFormatException e) {
            return ((String)o1).compareTo(((String)o2));
        }
    }
}

