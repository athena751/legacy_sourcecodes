/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: LdPathComparator.java,v 1.1 2005/10/26 01:35:09 jiangfx Exp $
 *
 */

package com.nec.nsgui.action.filesystem;

import java.util.Comparator;

/**
 *  
 *
 * @author  $Author: jiangfx $
 * @version $Revision: 1.1 $
 */

public class LdPathComparator implements Comparator {
    private static final String cvsid = "@(#) $Id: LdPathComparator.java,v 1.1 2005/10/26 01:35:09 jiangfx Exp $";
    public int compare(Object o1, Object o2){
        if(o1 == null && o2 == null) return 0;
        if(o1 == null) return -1;
        if(o2 == null) return 1;
        String str1 = (String)o1;
        String str2 = (String)o2;
        Double d1 = new Double(Double.NEGATIVE_INFINITY);
        Double d2 = new Double(Double.NEGATIVE_INFINITY);
        try{
           d1 = new Double(str1.replaceAll("/dev/ld",""));
        }catch(Exception e){
        }
        try{
            d2 = new Double(str2.replaceAll("/dev/ld",""));
        }catch(Exception e){
        }
        return d1.compareTo(d2);
    }
}

