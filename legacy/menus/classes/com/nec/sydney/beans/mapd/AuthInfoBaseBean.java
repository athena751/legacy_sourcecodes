/*
 *      Copyright (c) 2001 NEC Corporation
 * 
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.mapd;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.license.*;
import com.nec.sydney.beans.license.*;

public class AuthInfoBaseBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg
{



    private static final String     cvsid = "@(#) $Id: AuthInfoBaseBean.java,v 1.2303 2005/08/29 00:58:40 wangzf Exp $";

    protected String useMap;
    protected String  authType;
    protected boolean hasNIS;
    protected boolean hasPWD;
    protected boolean hasSHR;
    protected boolean hasDMC;
    protected String server;
    protected String domain;
    protected String pwdPath;
    protected String groupPath;
    protected String shrPath;
    protected String region;
    protected String mountpoint;
    protected String exportroot;
    protected String previous;
    protected boolean hasAuth;
    protected String path;

    protected String userName;
    protected String uid;
    protected String groupName;
    protected String gid;

    protected String privilege;

    protected AuthDomain auth;

    protected boolean licenseSXFSW;

    public AuthInfoBaseBean(){
         useMap="";
         authType="";
         hasNIS=false;
         hasPWD=false;
         hasSHR=false;
         hasDMC=false;
         server="";
         domain="";
         pwdPath="";
         groupPath="";
         shrPath="";
         region="";
         mountpoint="";
         exportroot="";
         previous="";
         hasAuth=false;
         path="";
         userName="";
         uid="";
         groupName="";
         gid="";
    }

    public AuthDomain getAuth(){
        return auth;
    }

    public void beanProcess() throws Exception{
        LicenseInfoSOAPClient sc = new LicenseInfoSOAPClient();
        LicenseInfo li = sc.getLicenseInfo(target);
        licenseSXFSW=(li.checkAvailable(NSMessageDriver.getInstance().getMessage(session,"license/sxfsw"))!=0)?true:false;
    }

    public boolean getLicenseSXFSW() throws Exception{
        return licenseSXFSW;
    }

    public AuthDomain getAuthByType(String kind) throws Exception{
        String exportroot=(String)session.getAttribute(MP_SESSION_EXPORTROOT);
        return getAuthInfoForExport(exportroot,kind);
    }

    public AuthDomain getAuthByType(String exportroot,String kind) throws Exception{        
        return getAuthInfoForExport(exportroot,kind);
    }
    
    public String getFSType() throws Exception{
        String path=(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        return MAPDSOAPClient.getFsType(target,path);
    }
    

    public AuthDomain getAuthInfoForExport(String exportroot,String kind) throws Exception
    {
        if( (kind==null)
            ||(kind.equals("")) ){
                return null;
        }
        AuthDomain auth = 
            APISOAPClient.getAuthDomainByKind(target, exportroot, kind);
        return auth;
    }

    public void setTarget(String x){
        target=x;
    }

    //public void setKind(String x){
    //    kind=x;
    //}

    public void setRegion(String x){
        region=x;
    }

    public void setExportroot(String x){
        exportroot=x;
    }

    public String getUseMap()
    {
        return useMap;
    }
    public String getServer()
    {
        return server;
    }
    public String getDomain()
    {
        return domain;
    }
    public String getPwdPath()
    {
        return pwdPath;
    }
    public String getGroupPath()
    {
        return groupPath;
    }
    public String getShrPath()
    {
        return shrPath;
    }
    public String getRegion()
    {
        return region;
    }
    public String getMountpoint()
    {
        return mountpoint;
    }
    public String getPrevious()
    {
        return previous;
    }
    public String getExportroot()
    {
        return exportroot;
    }
    public String getAuthType()
    {        
        return authType;
    }
    public String getMountPointPath()
    {
        return (exportroot+mountpoint);
    }
    public boolean getHasNIS()
    {
        return hasNIS;
    }
    public boolean getHasDMC()
    {
        return hasDMC;
    }
    public boolean getHasPWD()
    {
        return hasPWD;
    }
    public boolean getHasSHR()
    {
        return hasSHR;
    }
    public boolean  getHasAuth()
    {
        return hasAuth;
    }
    public String getUserName()
    {
        return userName;
    }
    public String getUID()
    {
        return uid;
    }
    public String getGroupName()
    {
        return groupName;
    }
    public String getGID()
    {
        return gid;
    }
    public String authType(AuthDomain auth) throws Exception{
         if(auth!=null){
            if(auth instanceof AuthNISDomain4Win){
                return AuthDomain.AUTH_NISW;
            }else if(auth instanceof AuthNISDomain){
                return AuthDomain.AUTH_NIS;
            }else if(auth instanceof AuthPWDDomain4Win){
                return AuthDomain.AUTH_PWDW;
            }else if(auth instanceof AuthPWDDomain){
                return AuthDomain.AUTH_PWD;
            }else if(auth instanceof AuthSHRDomain){
                return AuthDomain.AUTH_SHR;
            }else if(auth instanceof AuthDMCDomain){
                return AuthDomain.AUTH_DMC;
            }else if(auth instanceof AuthADSDomain){
                return AuthDomain.AUTH_ADS;
            }else if(auth instanceof AuthLDAPUDomain){
                return AuthDomain.AUTH_LDAPU;
            }else if(auth instanceof AuthLDAPUDomain4Win){
                return AuthDomain.AUTH_LDAPUW;
            }
        }
        return "";
    }
}  // end of class