/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.nashead;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.nashead.NasheadActionConst;

//LUN information entity of diskarray
public class NasheadLunInfoBean {
	
	private static final String cvsid = "@(#) $Id: NasheadLunInfoBean.java,v 1.2 2005/10/24 07:19:47 liuyq Exp $";
	
	private static final String LUN_OFFLINE = "-";
	private static final String LUN_OFFLINE_DISPLAY = "------";
	
	private String storage = "";      //storage name of LUN
 	private String LUN     = "";      //Logical Unit Number
	private String state   = "";      //LUN state, value is "NML","FLT" or "---"
	
    
    public void setStorage(String storage) {
        this.storage = storage;
    }
        
    public void setLUN(String LUN) {
        this.LUN = LUN;
    }
        
    public void setState(String state) {
        this.state = state;
    }
        
	public String getStorage() {
		return storage;
    }
        
    
    public String getLUN() throws Exception {
        	
        if ((LUN == null) || (LUN.equals("")) || (LUN.equals(LUN_OFFLINE))) {
        	return LUN_OFFLINE_DISPLAY;
        } 
        
        if (LUN.equals(NasheadActionConst.CONSTANT_NULL_VALUE)) {
        	return LUN;
        }
        	
        StringBuffer LUNBuf = new StringBuffer(LUN);
        	
        LUNBuf.append("(");
        LUNBuf.append(NSActionUtil.getHexString(4, LUN));
        LUNBuf.append(")");
        	
        return LUNBuf.toString();
        	 
    }
        
    public String getState() {
        return state;
    }
    
    
}
