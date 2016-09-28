/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.mapd;

public class AuthInfo{

    private static final String     cvsid = "@(#) $Id: AuthInfo.java,v 1.2303 2004/11/12 02:35:25 caoyh Exp $";


        private String usage;
        private boolean useMap;
        private boolean cifsAccess;
        private String server;
        private String oldServer;
        private String domain;

        private String pwdPath;
        private String groupPath;

        private String SHRPath;
        private String authType;
        private boolean hasNIS;
        private boolean hasSHR;
        private boolean hasDMC;
        private boolean hasPWD;
        private String region;
        private String exportRoot;
        private String mountPoint;
        private String path;
        private boolean  hasAuth;
        private String nameChange;
        private String globalDomain;
        private String localDomain;
        private String netBios;

        private String userName;
        private String uid;
        private String groupName;
        private String gid;

        private String password;

        private boolean smbNeed;

        private boolean hasNISU=false;
        private boolean hasNISW=false;
        private boolean hasPWDU=false;
        private boolean hasPWDW=false;
        private boolean hasLDAPU=false;
        private boolean hasLDAPW=false;
        private boolean hasADS=false;

        private String ludb="";
        private String fileSystem="";

        private String dnsDomain = "";
        private String kdcServer = "";

        private boolean fromCIFS=false;
        
        private String utoa="n";

    public String getUtoa(){
        return utoa;
    }
    public void setUtoa(String utoa){
        this. utoa = utoa;
    }

    public void setFromCIFS(boolean x){
        fromCIFS=x;
    }

    public boolean isFromCIFS(){
        return fromCIFS;
    }

        
    public void setFileSystem(String x){
        fileSystem=x;
    }

    public String getFileSystem(){
        return fileSystem;
    }

    public void setLUDB(String x){
        ludb=x;
    }

    public String getLUDB(){
        return ludb;
    }

    public void setHasNISU(boolean x){
        hasNISU=x;
    }

    public boolean getHasNISU(){
        return hasNISU;
    }

    public void setHasNISW(boolean x){
        hasNISW=x;
    }

    public boolean getHasNISW(){
        return hasNISW;
    }

    public void setHasPWDU(boolean x){
        hasPWDU=x;
    }

    public boolean getHasPWDU(){
        return hasPWDU;
    }

    public void setHasPWDW(boolean x){
        hasPWDW=x;
    }

    public boolean getHasPWDW(){
        return hasPWDW;
    }

    public void setHasLDAPU(boolean x){
        hasLDAPU=x;
    }

    public boolean getHasLDAPU(){
        return hasLDAPU;
    }

    public void setHasLDAPW(boolean x){
        hasLDAPW=x;
    }

    public boolean getHasLDAPW(){
        return hasLDAPW;
    }


    public AuthInfo()
    {
        smbNeed=true;

        usage="";
        useMap=false;
        cifsAccess=false;

        password="";

        server="";
        oldServer="";
        domain="";
        pwdPath="";
        groupPath="";

        SHRPath="";
        authType="";
        hasNIS=false;
        hasSHR=false;
        hasDMC=false;
        hasPWD=false;
        region="";
        exportRoot="";
        mountPoint="";
        path="";
        hasAuth=false;
        nameChange="";
    }

    public boolean getSmbNeed(){
        return smbNeed;
    }

    public void setSmbNeed(boolean x){
        this.smbNeed=x;
    }

    public String getUsage(){
        return usage;
    }

    public void setUsage(String usage){
        this.usage=usage;
    }

    public boolean getUseMap(){
        return useMap;
    }

    public void setUseMap(boolean useMap){
        this.useMap=useMap;
    }

    public boolean getCifsAccess(){
        return cifsAccess;
    }

    public void setCifsAccess(boolean cifsAccess){
        this.cifsAccess=cifsAccess;
    }

    public String getPassword(){
        return password;
    }

    public void setPassword(String password){
        this.password=password;
    }

    public String getServer(){
        return server;
    }

    public void setServer(String server){
        this.server=server;
    }

    public String getDomain(){
        return domain;
    }

    public void setDomain(String domain){
        this.domain=domain;
    }

    public String getPWDPath(){
        return pwdPath;
    }

    public void setPWDPath(String pwdPath){
        this.pwdPath=pwdPath;
    }

    public String getGroupPath(){
        return groupPath;
    }

    public void setGroupPath(String groupPath){
        this.groupPath=groupPath;
    }

    public String getSHRPath(){
        return SHRPath;
    }

    public void setSHRPath(String SHRPath){
        this.SHRPath=SHRPath;
    }
    public String getAuthType(){
        return authType;
    }

    public void setAuthType(String authType){
        this.authType=authType;
    }

    public boolean getHasNIS(){
        return hasNIS;
    }

    public void setHasNIS(boolean hasNIS){
        this.hasNIS=hasNIS;
    }

    public boolean getHasSHR(){
        return hasSHR;
    }

    public void setHasSHR(boolean hasSHR){
        this.hasSHR=hasSHR;
    }

    public boolean getHasPWD(){
        return hasPWD;
    }

    public void setHasPWD(boolean hasPWD){
        this.hasPWD=hasPWD;
    }

    public boolean getHasDMC(){
        return hasDMC;
    }

    public void setHasDMC(boolean hasDMC){
        this.hasDMC=hasDMC;
    }

    public boolean getHasADS(){
        return hasADS;
    }

    public void setHasADS(boolean hasADS){
        this.hasADS=hasADS;
    }


    public String getExportRoot(){
        return exportRoot;
    }

    public void setExportRoot(String exportRoot){
        this.exportRoot=exportRoot;
    }

    public String getMountPoint(){
        return mountPoint;
    }

    public void setMountPoint(String mountPoint){
        this.mountPoint=mountPoint;
    }

    public String getRegion(){
        return region;
    }

    public void setRegion(String region){
        this.region=region;
    }

    public String getPath(){
        return path;
    }

    public void setPath(String path){
        this.path=path;
    }

    public String getNameChange(){
        return nameChange;
    }

    public void setNameChange(String nameChange){
        this.nameChange=nameChange;
    }

    public String getOldServer(){
        return oldServer;
    }

    public void setOldServer(String oldServer){
        this.oldServer=oldServer;
    }

    public boolean getHasAuth(){
        return hasAuth;
    }

    public void setHasAuth(boolean hasAuth){
        this.hasAuth=hasAuth;
    }

/////
    public String getGlobalDomain()
    {
        return globalDomain;
    }
    public void setGlobalDomain(String s)
    {
        globalDomain=s;
    }

    public String getLocalDomain()
    {
        return localDomain;
    }
    public void setLocalDomain(String s)
    {
        localDomain=s;
    }

    public String getNetBios()
    {
        return netBios;
    }
    public void setNetBios(String s)
    {
        netBios=s;
    }

    public String getUserName()
    {
        return userName;
    }
    public void setUserName(String s)
    {
        userName=s;
    }

    public String getUID()
    {
        return uid;
    }
    public void setUID(String s)
    {
        uid=s;
    }

    public String getGroupName()
    {
        return groupName;
    }
    public void setGroupName(String s)
    {
        groupName=s;
    }

    public String getGID()
    {
        return gid;
    }
    public void setGID(String s)
    {
        gid=s;
    }

        //==============================================
        private String serverName;
    private String distinguishedName;
    private String authenticateType;
    private String TLS="";
    private String authenticateID;
    private String authenticatePasswd;
    private String CA;
    private String CAType = "no";
    private String userFilter = "";
    private String groupFilter = "";

    public final static String TYPE_SIMPLE = "SIMPLE";
    public final static String TYPE_MD5 = "DIGEST-MD5";
    public final static String TLS_YES = "yes";
    public final static String TLS_NO  = "no";
    public final static String CATYPE_NOSPECIFY = "no";
    public final static String CATYPE_FILE = "file";
    public final static String CATYPE_DIR = "dir";

    public String getUserFilter(){
        return userFilter;
    }
    
    public void setUserFilter(String userFilter){
        this.userFilter = userFilter;
    }

    public String getGroupFilter(){
        return groupFilter;
    }
    
    public void setGroupFilter(String groupFilter){
        this. groupFilter = groupFilter;
    }

    public void setServerName(String name){
	serverName = name;
    }
    public void setDistinguishedName(String name){
	distinguishedName = name;
    }
    public void setAuthenticateType(String type){
	authenticateType = type;
    }
    public void setTLS(String tls){
        if (tls==null){
            tls = "";
        }
	TLS = tls;
    }
    public void setAuthenticateID(String id){
	authenticateID = id;
    }
    public void setAuthenticatePasswd(String passwd){
	authenticatePasswd = passwd;
    }
    public void setCA(String ca){
	CA = ca;
    }
    public void setCAType(String type){
        this.CAType = type;
    }
    public String getServerName(){
	return serverName;
    }
    public String getDistinguishedName(){
	return distinguishedName;
    }
    public String getAuthenticateType(){
	return authenticateType;
    }
    public String getTLS(){
	return TLS;
    }
    public String getAuthenticateID(){
	return authenticateID;
    }
    public String getAuthenticatePasswd(){
	return authenticatePasswd;
    }
    public String getCA(){
	return CA;
    }
    public String getCAType(){
        return CAType;
    }

    public void setDNSDomain(String dom){
        dnsDomain = dom;
    }

    public String getDNSDomain(){
        return dnsDomain;
    }

    public void setKDCServer(String svr){
        kdcServer = svr;
    }

    public String getKDCServer(){ 
        return kdcServer; 
    }

        //==============================================

}