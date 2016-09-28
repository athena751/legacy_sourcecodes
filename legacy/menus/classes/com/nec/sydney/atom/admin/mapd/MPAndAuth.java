package com.nec.sydney.atom.admin.mapd;

public class MPAndAuth{

    public static final String NONE="-";

    private String mp=NONE;
    private String domainType=NONE;
    private String domainName=NONE;
    private String resource=NONE;    

    private String ntdomain="";
    private String network="";
    private String ludbName="";

    private String hexMountPoint="";

    public String getNetwork(){
        return network;
    }

    public void setNetwork(String x){
        this.network=x;
    }

    public String getNTDomain(){
        return ntdomain;
    }
    public String getNtdomain(){
            return ntdomain;
    }
    public void setNtdomain(String x){
            this.ntdomain=x;
        }   
    public void setNTDomain(String x){
        this.ntdomain=x;
    }

    public String getHexMountPoint(){
        return hexMountPoint;
    }

    public void setHexMountPoint(String hexMountPoint){
        this.hexMountPoint=hexMountPoint;
    }

    public String getMp(){
        return mp;
    }

    public void setMp(String mp){
        this.mp=mp;
    }

    public String getDomainType(){
        return domainType;
    }

    public void setDomainType(String domainType){
        this.domainType=domainType;
    }

    public String getDomainName(){
        return domainName;
    }

    public void setDomainName(String domainName){
        this.domainName=domainName;
    }

    public String getResource(){
        return resource;
    }

    public void setResource(String resource){
        this.resource=resource;
    }
    
    public String getLudbName(){
        return ludbName;
    }

    public void setLudbName(String name){
        this.ludbName=name;
    }

}
