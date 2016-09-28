/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.atom.admin.mapd;

public class DomainInfo{  

    private static final String cvsid = "@(#) $Id: DomainInfo.java,v 1.2 2004/11/12 02:36:16 zhangjx Exp $";
    
    private String domaintype = "";
    private String region = "";
    private String netbios = "";
    private String ntdomain = "";
    private String nisdomain = "";
    private String nisserver = "";
    private String ludb = "";
    private String ldapserver = "";
    private String basedn = "";
    private String mech = "";
    private String tls = "";
    private String authname = "";
    private String authpwd = "";
    private String ca = "";
    private String ufilter = "";
    private String gfilter = "";
    private String dns = "";
    private String kdcserver = "";
    private String username = "";
    private String passwd = "";
    private String un2dn = "";
    
    private String resource = "";
    private String type4show = "";
  
    public void setDomainType(String x){
        domaintype = x;
    }
    
    public String getDomainType(){
        return domaintype;
    } 
    
    public void setRegion(String x){
        region = x;
    }
    
    public String getRegion(){
        return region;
    }
    
    public void setNetbios(String x){
        netbios = x;
    }
    
    public String getNetbios(){
        return netbios;
    }
    
    public void setNtdomain(String x){
        ntdomain = x;
    }
    
    public String getNtdomain(){
        return ntdomain;
    }
    
    public void setNisdomain(String x){
        nisdomain = x;
    }
    
    public String getNisdomain(){
        return nisdomain;
    }
    
    public void setNisserver(String x){
        nisserver = x;
    }
    
    public String getNisserver(){
        return nisserver;
    }
    
    public void setLudb(String x){
        ludb = x;
    }
    
    public String getLudb(){
        return ludb;
    }
    
    public void setLdapserver(String x){
        ldapserver = x;
    }
    
    public String getLdapserver(){
        return ldapserver;
    }
    
    public void setBasedn(String x){
        basedn = x;
    }
    
    public String getBasedn(){
        return basedn;
    }
    
    public void setMech(String x){
        mech = x;
    }
    
    public String getMech(){
        return mech;
    }
    
    public void setTls(String x){
        tls = x;
    }
    
    public String getTls(){
        return tls;
    }
    
    public void setAuthname(String x){
        authname = x;
    }
    
    public String getAuthname(){
        return authname;
    }
    
    public void setAuthpwd(String x){
        authpwd = x;
    }
    
    public String getAuthpwd(){
        return authpwd;
    }
    
    public void setCa(String x){
        ca = x;
    }
    
    public String getCa(){
        return ca;
    }
    
    public void setUfilter(String x){
        ufilter = x;
    }
    
    public String getUfilter(){
        return ufilter;
    }
    
    public void setGfilter(String x){
        gfilter = x;
    }
    
    public String getGfilter(){
        return gfilter;
    }
    
    public void setDns(String x){
        dns = x;
    }
    
    public String getDns(){
        return dns;
    }
    
    public void setKdcserver(String x){
        kdcserver = x;
    }
    
    public String getKdcserver(){
        return kdcserver;
    }
    
    public void setUsername(String x){
        username = x;
    }
    
    public String getUsername(){
        return username;
    }
    
    public void setPasswd(String x){
        passwd = x;
    }
    
    public String getPasswd(){
        return passwd;
    } 
    
    public void setResource(String x){
        resource = x;
    }
    
    public String getResource(){
        return resource;
    }
    
    public void setType4show(String x){
        type4show = x;
    }
    
    public String getType4show(){
        return type4show;
    }
    
    public void setUn2dn(String x){
        un2dn = x;
    }
    
    public String getUn2dn(){
        return un2dn;
    }
    
    
   
}