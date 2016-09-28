
/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: StorageLunComparator.java,v 1.1 2005/06/13 01:42:19 liuyq Exp $
 *
 */



package com.nec.nsgui.action.volume;

import java.util.Comparator;

/**
 * @author  $Author: liuyq $
 * @version $Revision: 1.1 $
 */

public class StorageLunComparator implements Comparator {
    public int compare(Object o1, Object o2){
        if(o1 == null && o2 == null) return 0;
        if(o1 == null) return -1;
        if(o2 == null) return 1;
        String  lunStorage1 = ((String)o1).split("<BR>")[0];
        String  lunStorage2 = ((String)o2).split("<BR>")[0];
        String  lun1 = lunStorage1.split("/")[0].trim();
        String  lun2 = lunStorage2.split("/")[0].trim();
        String  storage1 = lunStorage1.split("/")[1].trim();
        String  storage2 = lunStorage2.split("/")[1].trim();

        int comp = storage1.compareTo(storage2); 
        if( comp != 0){
            return comp;
        }else{
            String lunHex1 = lun1.substring(lun1.indexOf("(") + 1,lun1.indexOf(")"));
            String lunHex2 = lun2.substring(lun2.indexOf("(") + 1,lun2.indexOf(")"));
            return lunHex1.compareTo(lunHex2);
        }
    }

}

