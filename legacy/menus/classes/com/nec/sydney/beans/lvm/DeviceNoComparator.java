/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */
package com.nec.sydney.beans.lvm;
import java.util.Comparator;

/**
 * @author  $Author: liuyq $
 * @version $Revision: 1.2 $
 */

public class DeviceNoComparator implements Comparator {
    public static final String cvsid =
        "@(#) $Id: DeviceNoComparator.java,v 1.2 2005/10/24 06:04:17 liuyq Exp $";
    public int compare(Object o1, Object o2){
        if(o1 == null && o2 == null) return 0;
        if(o1 == null) return -1;
        if(o2 == null) return 1;
        String [] compObj1 = ((String)o1).split(":");
        String [] compObj2 = ((String)o2).split(":");
        if (compObj1[0].equals(compObj2[0])){
            Integer minor1, minor2;
            try{
                minor1 = Integer.valueOf(compObj1[1].toString());
            }catch(Exception e){
                return -1;
            }
            try{
                minor2 = Integer.valueOf(compObj2[1].toString());
            }catch(Exception e){
                return 1;
            }
            return  minor1.compareTo(minor2);
        }else{
            Integer major1, major2;
            try{
                major1 = Integer.valueOf(compObj1[0].toString());    
            }catch(Exception e){
                return -1;
            }
            try{
                major2 = Integer.valueOf(compObj2[0].toString());    
            }catch(Exception e){
                return 1;
            }
            return  major1.compareTo(major2);
        }    
    }

}

