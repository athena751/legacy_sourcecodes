/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.mapd;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import java.util.*;
public class AuthInfoBean extends AuthInfoBaseBean implements NasConstants,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: AuthInfoBean.java,v 1.2309 2005/08/29 00:58:40 wangzf Exp $";

    String type="";
    String hexPath="";    
    String ludb="";
    private String hasLdapSam;
    public AuthInfoBean() throws Exception{
    }

    public void beanProcess() throws Exception{
        super.beanProcess();
        exportroot=(String)session.getAttribute(MP_SESSION_EXPORTROOT);
        hexPath=(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);       
        mountpoint = (String)session.getAttribute(MP_SESSION_MOUNTPOINT);

        type=request.getParameter("commonType");
        if (type == null){
            type = "";
        }
        previous=request.getParameter("Previous");
        if (previous == null){
            previous = "";
        }
        String nasAction=request.getParameter("nasAction");
        if(nasAction==null){
            onInitial();
        }else if(nasAction.equals("Set")){
            if (onCreate() != 0)
                return;
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
            super.response.sendRedirect
                    (super.response.encodeRedirectURL("mapdauth.jsp?target="+target+"&Previous="+previous));
        }else if(nasAction.equals("unSet")){
            MapdCommon.unsetAuth(session,request,target);
            String[] files = {CLUSTER_FILE_IMS_CONF};
            super.remoteSync(files);
            super.setMsg(NSMessageDriver.getInstance().
                    getMessage(session, "common/alert/done"));
            super.response.sendRedirect
                    (super.response.encodeRedirectURL("mapdauth.jsp?target="+target+"&Previous="+previous));
        }else{
            onInitial();
        }

        
    }

    public String getDefaultLudb() throws Exception{
        if (ludb == null || ludb.equals("")){
            AuthPWDDomain pwdDomain;
            String fsType = getFSType();
            if(fsType.equals("sxfs")){
                pwdDomain = (AuthPWDDomain)getAuthByType(AuthDomain.AUTH_PWD);
            }else{
                pwdDomain = (AuthPWDDomain4Win)getAuthByType(AuthDomain.AUTH_PWDW);
            }
            if(pwdDomain!=null){
                String pwdPath = NSUtil.bytes2hStr(pwdDomain.getPasswd());
                pwdPath=NSUtil.hStr2EncodeStr(pwdPath, NSUtil.EUC_JP, BROWSER_ENCODE);
                
                if(!MapdCommon.checkPwd(pwdPath,exportroot,fsType,"/passwd",target)){
                   throw new Exception(NSMessageDriver.getInstance().getMessage
                                (session, "nas_mapd/alert/old_pass"));
                    }
                ludb = MapdCommon.trimPwd(pwdPath,exportroot,fsType,target);  
            }
            return ludb;
        }else {
            return ludb;
        }
    }

    public void onInitial() throws Exception{       
        AuthDomain auth = APISOAPClient.getAuthDomain(target, hexPath);
        if (auth == null){
            return;
        }
        hasAuth = true;
        authType=authType(auth);
    }

    public int onCreate() throws Exception{
        try{
            AuthInfo auth = new AuthInfo();
            auth.setAuthType(type);
            if (type.equals(AuthDomain.AUTH_DMC)
                || type.equals(AuthDomain.AUTH_ADS)
                || type.equals(AuthDomain.AUTH_SHR)
                || type.equals(AuthDomain.AUTH_LDAPUW)
                || type.equals(AuthDomain.AUTH_NISW)
                || type.equals(AuthDomain.AUTH_PWDW)){
               setAuthLocalAndNet(auth);
            }

            String smbFile = "$/etc/group%/:"+GLOBALDOMAIN+":"
                                 +auth.getLocalDomain()+":"+auth.getNetBios();

            if(type.equals(AuthDomain.AUTH_NIS)
                     ||type.equals(AuthDomain.AUTH_NISW)){

                MapdCommon.setAuthNIS(session,request,auth,target);
                
                if(type.equals(AuthDomain.AUTH_NIS)){
                    String[] files = {CLUSTER_FILE_IMS_CONF};
                    super.remoteSync(files);
                }else{
                    String[] files = {smbFile,CLUSTER_FILE_IMS_CONF};
                    super.remoteSync(files);
                }
                
            }else if(type.equals(AuthDomain.AUTH_PWD)
                     ||type.equals(AuthDomain.AUTH_PWDW)){

                auth.setFileSystem(getFSType());

                MapdCommon.setAuthPWD(session,request,auth,target);

                if(type.equals(AuthDomain.AUTH_PWD)){
                    String[] files = {CLUSTER_FILE_IMS_CONF};
                    super.remoteSync(files);
                }else{
                   String[] files = {smbFile,CLUSTER_FILE_IMS_CONF};
                    super.remoteSync(files);
                }
            }else if(type.equals(AuthDomain.AUTH_SHR)){

                MapdCommon.setAuthSession(session,auth);
                setAuthSHR(auth);
            }else if(type.equals(AuthDomain.AUTH_DMC)){
                MapdCommon.setAuthSession(session,auth);
                if (setAuthDMC(auth) != 0) return 1;
            }else if(type.equals(AuthDomain.AUTH_ADS)){
                if (setAuthADS(auth) != 0) return 1;
            }else if(type.equals(AuthDomain.AUTH_LDAPU)
                     ||type.equals(AuthDomain.AUTH_LDAPUW)){

                MapdCommon.setAuthLDAP(session,request,auth,target);

                if(type.equals(AuthDomain.AUTH_LDAPU)){
                    String[] files = {CLUSTER_FILE_IMS_CONF};
                    super.remoteSync(files);
                }else{
                    String[] files = {smbFile,CLUSTER_FILE_IMS_CONF};
                    super.remoteSync(files);
                }
            }
            return 0;
        }catch (NSException ex){
            String errMsg;
            switch(ex.getErrorCode()){
                case NAS_EXCEP_NO_MAPD_LOCALDOMAIN_FAILED:
                    errMsg=NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session,"exception/mapd/set_localdomain");
                    super.setMsg(errMsg);
                    super.response.sendRedirect(super.response.encodeRedirectURL("../cifs/localdomain.jsp"));
                    return 1;
                case NAS_EXCEP_NO_MAPD_NIS_EXIST_FAILED:
                    errMsg=NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session,"exception/mapd/authdomain_same");
                    super.setMsg(errMsg);
                    super.response.sendRedirect(super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous+"&commonType="+type));
                    return 1;
                case NAS_EXCEP_NO_MAPD_NIS_SERVER_FAILED:
                    errMsg=NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/nis_server_failed");
                    super.setMsg(errMsg);
                    super.response.sendRedirect(super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous+"&commonType="+type));
                    return 1;
                case 101:  // the domain security mode has been set , exit by perl mapd_buildsid.pl
                    errMsg=NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/dmcHasSet");
                    super.setMsg(errMsg);
                    super.response.sendRedirect(super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous));
                    return 1;
                case 102:  // the share security mode has been set , exit by perl mapd_buildsid.pl
                    errMsg=NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/shrHasSet");
                    super.setMsg(errMsg);
                    super.response.sendRedirect(super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous));
                    return 1;
                    //break;
                case 103:  // the ads security mode has been set , exit by perl mapd_buildsid.pl
                    errMsg=NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/adsHasSet");
                    super.setMsg(errMsg);
                    super.response.sendRedirect(super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous));
                    return 1;
                case NAS_EXCEP_NO_MAPD_LDAP_ADD_FAILED:
                    errMsg=NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ldapAddFail");
                    super.setMsg(errMsg);
                    super.response.sendRedirect(super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous+"&commonType="+type));
                    return 1;
                default:
                    throw ex;
            } //END of switch
        }
    }

    public void setAuthSHR(AuthInfo auth) throws Exception{

        auth.setMountPoint(mountpoint);

        auth.setUserName("");
        auth.setUID("");
        auth.setGroupName("");
        auth.setGID("");
        auth.setSHRPath(NasConstants.AUTH_SHR_PATH);

        region=MAPDSOAPClient.setAuthSHR(target ,auth);

        boolean hasSHR=auth.getHasSHR();

        if (!hasSHR){
            String smbFile = "$/etc/group%/:" + GLOBALDOMAIN+":"
                             +auth.getLocalDomain()+":" + auth.getNetBios();

            String[] files = {smbFile,CLUSTER_FILE_IMS_CONF};
            super.remoteSync(files);
        } else {
            String[] files = {CLUSTER_FILE_IMS_CONF};
            super.remoteSync(files);
        }
    }

    public int setAuthDMC(AuthInfo auth) throws Exception{
        server="*";
        domain=auth.getLocalDomain();
        String nameChange=super.request.getParameter("nameChange");
        String username = request.getParameter("dmcUsername");
        String password = request.getParameter("_dmcPassword");

        auth.setDomain(domain);
        auth.setServer(server);
        auth.setOldServer(server);
        auth.setNameChange(nameChange);
        auth.setUserName(username);
        auth.setPassword(password);

        boolean hasAuth=auth.getHasAuth();
        try{
            if (hasAuth==true && nameChange.equals(REQUEST_PARAMETER_NAMECHANGE_VALUE)) {
                MapdCommonSOAPClient.joinDomain(target, AuthDomain.AUTH_DMC, 
                        domain, username, password,auth.getNetBios(),"");
            }else{
                if (hasAuth==false){
                    region=MAPDSOAPClient.setAuthDMC(target,auth);
                }
            }
        }catch(NSException ex){
            if (ex.getErrorCode()==NAS_EXCEP_NO_MAPD_DMC_SMBPASSWD_FAILED){
                String errMsg=NSMessageDriver.getInstance().
                                        getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().
                                        getMessage(session,"nas_mapd/alert/dmc_passwd_failed");
                super.setMsg(errMsg);
                super.response.sendRedirect(
                super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous+"&commonType="+type));
                return 1;
            }else{
                throw ex;
            }
        }

        String smbFile = "$/etc/group%/:"+GLOBALDOMAIN+":"
                             +auth.getLocalDomain()+":"+auth.getNetBios();
        String[] files = {smbFile,CLUSTER_FILE_IMS_CONF};
        super.remoteSync(files);
        return 0;
    }

    public int setAuthADS(AuthInfo auth) throws Exception{
        MapdCommon.setAuthSession(session,auth);
        String username = request.getParameter("adsUsername");
        String password = request.getParameter("_adsPassword");
        String dnsDomain   = request.getParameter("dnsDomain");
        String kdcServer   = request.getParameter("kdcServer");

        //use the dnsDomain as kdcServer, when the kdcServer is not specifed
        if (kdcServer == null || kdcServer.trim().equals("")){
            kdcServer = dnsDomain;
        }
        if (dnsDomain != null){
            dnsDomain = dnsDomain.toUpperCase();
        }
        domain = auth.getLocalDomain();
        auth.setDomain(domain);
        auth.setUserName(username);
        auth.setPassword(password); 
        auth.setDNSDomain(dnsDomain); 
        auth.setKDCServer(kdcServer); 

        boolean bCheck = false;     //checkout flag;
        boolean adsChange = false;  //update falg

        try{
            Vector adsInfo = MapdCommonSOAPClient.getADSConf(target, domain);

            if (adsInfo == null 
                || !dnsDomain.equals(adsInfo.get(0)) 
                || !kdcServer.equals(adsInfo.get(1))){
                adsChange = true;
            }            
            
            //1. write smb.conf.<netbios>
            MAPDSOAPClient.writeSMB4ADS(target, auth);

            //2. update krb5.conf and other smb.conf when ads info has been changed
            if (adsChange){
                MapdCommon.checkoutADSFiles(target, domain);
                bCheck = true;
                MapdCommon.setADSConf(target, domain, dnsDomain, kdcServer);
            }

            if (auth.getHasAuth()){
                MapdCommonSOAPClient.joinDomain(target, AuthDomain.AUTH_ADS, 
                        domain, username, password, auth.getNetBios(),auth.getDNSDomain());
            }else{
                MAPDSOAPClient.setAuthADS(target, auth);
            }
            if (bCheck){
                bCheck = false;
                MapdCommon.checkinADSFiles(target, domain);
            }
        }catch(NSException ex){
            if (bCheck){
                MapdCommon.rollbackADSFiles(target, domain);
            }
            if (ex.getErrorCode()==NAS_EXCEP_NO_MAPD_DMC_SMBPASSWD_FAILED){
                String errMsg=NSMessageDriver.getInstance().
                                        getMessage(session,"common/alert/failed")
                                +"\\r\\n"
                                +NSMessageDriver.getInstance().
                                        getMessage(session,"nas_mapd/alert/ads_passwd_failed");
                super.setMsg(errMsg);
                super.response.sendRedirect(
                super.response.encodeRedirectURL
                            ("mapdauth.jsp?target="+target+"&Previous="+previous+"&commonType="+type));
                return 1;
            }else{
                throw ex;
            }
        }
        return 0;
    }

    public void setAuthLocalAndNet(AuthInfo auth) throws Exception{
        LocalDomain ld =
            APISOAPClient.getLocalDomainInfo(target, exportroot);
        String localDomainName=ld.getLocalDomainName();
        List list=ld.getNetbios();
        String netBios=(String)list.get(0);

        auth.setGlobalDomain(GLOBALDOMAIN);
        auth.setLocalDomain(localDomainName);
        auth.setNetBios(netBios);
    }

    public boolean hasShow(){
        String local=null;
        String netBios = null;

        try{
            LocalDomain localDomain =
                APISOAPClient.getLocalDomainInfo(target, exportroot.trim());
            local=localDomain.getLocalDomainName();

            domain=local;
            List netbiosList = localDomain.getNetbios();
            if (netbiosList == null || netbiosList.size()==0
                || local==null || local.equals("") ){
                NSException ex = new NSException(this.getClass(), 
                    NSMessageDriver.getInstance().getMessage(session,
                    "exception/mapd/set_localdomain"));
                ex.setDetail("[ local = " + local + 
                      ", netBios.size = " + netbiosList.size() +"]");
                ex.setReportLevel(NSReporter.ERROR);
                ex.setErrorCode(NAS_EXCEP_NO_MAPD_LOCALDOMAIN_FAILED);
                NSReporter.getInstance().report(ex);
                throw ex;
            }
        }
        catch(Exception e){
            return false;
        }
        return true;
    }
    
    public AuthInfo getLDAPInfo() throws Exception {
        return MapdCommon.getLDAPInfo(target);
    }

    public String getHasLdapSam()throws Exception{
        if (hasLdapSam == null ){
            hasLdapSam = MapdCommon.getHasLdapSam(target);
        }
        return hasLdapSam;
    }

    public AuthInfo getADSInfo() throws Exception {
        LocalDomain ld =
            APISOAPClient.getLocalDomainInfo(target, exportroot);
        String ntDomain=ld.getLocalDomainName();
        Vector vec = MapdCommon.getADSConf(target, ntDomain);
        AuthInfo auth = new AuthInfo();
        if (vec != null){
            auth.setDNSDomain((String)vec.get(0));
            auth.setKDCServer((String)vec.get(1));
        }
        return auth;
    }
}