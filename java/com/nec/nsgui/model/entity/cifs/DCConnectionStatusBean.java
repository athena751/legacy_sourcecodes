/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.cifs;

/**
 *
 */
public class DCConnectionStatusBean {
    private static final String cvsid =
        "@(#) $Id: DCConnectionStatusBean.java,v 1.2 2006/05/12 09:30:09 fengmh Exp $";
    
    private String priority = "";
    private String domainController = "";
    private String accessStat = "";
    private String accessInfo = "";
    
    
    public String getAccessInfo() {
        return accessInfo;
    }
    
    public void setAccessInfo(String accessInfo) {
        this.accessInfo = accessInfo;
    }
    
    public String getAccessStat() {
        return accessStat;
    }
    
    public void setAccessStat(String accessStat) {
        this.accessStat = accessStat;
    }
    
    public String getDomainController() {
        return domainController;
    }
    
    public void setDomainController(String dcController) {
        this.domainController = dcController;
    }

    public String getPriority() {
        return priority;
    }
    

    public void setPriority(String priority) {
        this.priority = priority;
    }
    
    
}