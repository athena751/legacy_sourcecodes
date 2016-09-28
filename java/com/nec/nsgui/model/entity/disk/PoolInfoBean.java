/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.disk;
public class PoolInfoBean{
    private static final String cvsid = "@(#) $Id: PoolInfoBean.java,v 1.5 2007/05/09 06:49:26 liuyq Exp $";
    
    private String  poolnum="";
    private String  usedpd="";
    private String  notusedpd ="";
    private String  poolname="";
    private String  raidtype="6_10";
    private String	rbtime="23";
    private String  expandmode="off";
    private String  expandtime="0";
    
    
    public void setPoolnum(String poolnum){
        this.poolnum = poolnum;
    }
    public void setUsedpd(String usedpd){
        this.usedpd = usedpd;
    }
    public void setNotusedpd(String notusedpd){
        this.notusedpd = notusedpd;
    }
       
    public void setPoolname(String poolname){
        this.poolname = poolname;
    }
    public void setRaidtype(String raidtype){
        this.raidtype = raidtype;
    }
    public void setRbtime(String rbtime){
        this.rbtime = rbtime;
    }
    public void setExpandmode(String emode){
        this.expandmode=emode;
    }
    public void setExpandtime(String etime){
        this.expandtime=etime;
    }
        
    public String getPoolnum(){
        return this.poolnum;
    }
    public String getUsedpd(){
        return this.usedpd;
    }
    public String getNotusedpd(){
        return this.notusedpd;
    }
    public String getPoolname(){
        return this.poolname;
    }
    public String getRaidtype(){
        return this.raidtype;
    }
    public String getRbtime(){
        return this.rbtime;
    }
    public String getExpandmode(){
        return this.expandmode;
    }
    public String getExpandtime(){
        return this.expandtime;
    }
    
}        
    

