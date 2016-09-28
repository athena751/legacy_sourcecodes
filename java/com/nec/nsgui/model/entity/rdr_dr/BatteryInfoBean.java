/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.rdr_dr;

import com.nec.nsgui.action.rdr_dr.Rdr_drActionConst;
 
public class BatteryInfoBean implements Rdr_drActionConst {
    private static final String cvsid = "@(#) $Id: BatteryInfoBean.java,v 1.1 2005/01/24 10:39:21 jiangfx Exp $";
     
    // store battery status's info 
    private String name;           
    private String status;
    private String memoryBackup;
    private String nvram;
    
    private String limit;          // store battery's limit
    
    public void setName(String name) {
        this.name = name;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public void setMemoryBackup(String memoryBackup) {
        this.memoryBackup = memoryBackup;
    }
    
    public void setNvram(String nvram) {
        this.nvram = nvram;
    }
    
    public void setLimit(String limit) {
        this.limit = limit;
    }

    public String getName() {
        return name;
    }
  
    public String getStatus() {
        return status;
    }
    
    public String getMemoryBackup() {
        return memoryBackup;
    }
    
    public String getNvram() {
        return nvram;
    }
    
    public String getLimit() {
        return limit;
    }
    public void init(){
        String initValue = CONSTANT_NODATA;
		setStatus(initValue);
		setNvram(initValue);
		setMemoryBackup(initValue);
		setLimit(initValue);
	}
    
    public boolean isAvailable() {
		if((status==null) || (nvram==null) || (memoryBackup==null) || (limit==null)
	       || status.equals("") || nvram.equals("") || memoryBackup.equals("") || limit.equals("")){
	       return false;
		}
		return true;
    }
} 