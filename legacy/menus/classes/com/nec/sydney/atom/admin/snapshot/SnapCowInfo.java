/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.snapshot;

public class SnapCowInfo{

    private static final String     cvsid = "@(#) $Id: SnapCowInfo.java,v 1.2300 2003/11/24 00:54:44 nsadmin Exp $";
    
    public static final int INVALID_USEDCOW = -1;
    private int cowLimit;
    private int usedCow;
    
    //constructor
    public SnapCowInfo(){
       this.cowLimit = 0;
       this.usedCow = 0;    
    }

    public void setCowLimit(int cowLimit){    
       this.cowLimit = cowLimit;
    }
    
    public int getCowLimit(){
       return this.cowLimit;
    }
    
    public void setUsedCow(int usedCow){
       this.usedCow = usedCow;
    }
        
    public int getUsedCow(){
       return this.usedCow;
    }
}
