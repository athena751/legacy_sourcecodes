/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.filesystem;

public class FreeLdInfoBean {

    private static final String cvsid = "@(#) $Id: FreeLdInfoBean.java,v 1.1 2005/06/10 09:44:14 jiangfx Exp $";
    
    private String ldNo = "";     // property is valid in NV
    
    private String ldPath = "";   // property is valid in both NV and NASHead
    private String ldSize = "";   // property is valid in both NV and NASHead
    
    private String lun     = "";  // property is valid in NASHead
    private String storage = "";  // property is valid in NASHead
    
    public String getLdNo() {
        return ldNo;
    }
    
    public String getLdPath() {
        return ldPath;
    }
    
    public String getLdSize() {
        return ldSize; 
    }
    
    public String getLun() {
        return lun;
    }
    
    public String getStorage() {
        return storage;
    }
    
    public void setLdNo(String ldNo) {
        this.ldNo = ldNo;
    }
    
    public void setLdPath(String ldPath) {
        this.ldPath = ldPath;
    }
    
    public void setLdSize(String ldSize) {
        this.ldSize = ldSize;
    }
    
    public void setLun(String lun) {
        this.lun = lun;
    }
    
    public void setStorage(String storage) {
        this.storage = storage;
    }
}