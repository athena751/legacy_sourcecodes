/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.mapd;

public class DMountInfoBean{  

    private static final String cvsid = "@(#) $Id: DMountInfoBean.java,v 1.1 2005/06/13 08:11:00 liq Exp $";
    
    private String mp = "";
    private String fsType = "";
    private String hasAuth = "";
    private String domainType = "";
    private DomainInfoBean dinfo = new DomainInfoBean();
    
    
    public void setMp(String x){
        mp = x;
    }
    
    public String getMp(){
        return mp;
    }
    
    public void setFsType(String x){
        fsType = x;
    }
    
    public String getFsType(){
        return fsType;
    }
    
    public void setHasAuth(String x){
        hasAuth = x;
    }
    
    public String getHasAuth(){
        return hasAuth;
    }
    
    public void setDomainType(String x){
        domainType = x;
    }
    
    public String getDomainType(){
        return domainType;
    }
    
    public void setDinfo(DomainInfoBean x){
        dinfo = x;
    }
    
    public DomainInfoBean getDinfo(){
        return dinfo;
    }
}