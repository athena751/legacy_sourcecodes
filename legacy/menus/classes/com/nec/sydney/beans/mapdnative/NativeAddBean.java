/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.mapdnative;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.api.*;

public class NativeAddBean extends AbstractJSPBean implements NSExceptionMsg,NasConstants,NasSession {

    private static final String     cvsid = "@(#) $Id: NativeAddBean.java,v 1.2307 2005/08/29 00:58:54 wangzf Exp $";

    private String username="";
    private String password="";
    private String hasLdapSam;

    public void beanProcess()throws Exception {
        String type = request.getParameter("commonType");
        String nasAction = request.getParameter("nasAction");
        if (nasAction == null || nasAction.equals("")){
            return;
        }
        String addType = "unix";
        NativeDomain nati = new NativeNISDomain(); // no use, just for compiling.
        if(type.equals(NativeDomain.NATIVE_NIS)){
            nati=new NativeNISDomain();
            ((NativeNISDomain)nati).setNetwork( request.getParameter("network") );
            ((NativeNISDomain)nati).setDomainName( request.getParameter("nisDomain") );
            ((NativeNISDomain)nati).setDomainServer( request.getParameter("nisServer") );
        }else if(type.equals(NativeDomain.NATIVE_PWD)){
            nati=new NativePWDDomain();
            ((NativePWDDomain)nati).setNetwork( request.getParameter("network") );
            String ludb=request.getParameter("pwdLudb");
            String pwdPath=MapdCommon.mergePwd("","sxfs",ludb,"/passwd",target);
            String groupPath=MapdCommon.mergePwd("","sxfs",ludb,"/group",target);
            ((NativePWDDomain)nati).setPasswd( pwdPath.getBytes(NSUtil.EUC_JP));
            ((NativePWDDomain)nati).setGroup( groupPath.getBytes(NSUtil.EUC_JP));
        }else if(type.equals(NativeDomain.NATIVE_LDAPU)){
            nati=new NativeLDAPUDomain();
            ldapInfo((NativeLDAPDomain)nati);
        }else if(type.equals(NativeDomain.NATIVE_LDAPUW)){
            nati=new NativeLDAPUDomain4Win();
            ldapInfo((NativeLDAPDomain)nati);
            addType="win";
        }else if(type.equals(NativeDomain.NATIVE_NISW)){
            nati=new NativeNISDomain4Win();
            ((NativeNISDomain4Win)nati).setNTDomain( request.getParameter("winDomain") + "+" + request.getParameter("netbiosName") );                
            ((NativeNISDomain4Win)nati).setDomainName( request.getParameter("nisDomain") );
            ((NativeNISDomain4Win)nati).setDomainServer( request.getParameter("nisServer") );
            addType="win";               
        }else if(type.equals(NativeDomain.NATIVE_PWDW)){
            nati=new NativePWDDomain4Win();
            ((NativePWDDomain4Win)nati).setNTDomain( request.getParameter("winDomain") + "+" + request.getParameter("netbiosName") ); 
            String ludb=request.getParameter("pwdLudb");
            String pwdPath=MapdCommon.mergePwd("","sxfsfw",ludb,"/passwd",target);
            String groupPath=MapdCommon.mergePwd("","sxfsfw",ludb,"/group",target);
            ((NativePWDDomain4Win)nati).setPasswd( pwdPath.getBytes(NSUtil.EUC_JP));
            ((NativePWDDomain4Win)nati).setGroup( groupPath.getBytes(NSUtil.EUC_JP));
            addType="win";
        }else if(type.equals(NativeDomain.NATIVE_DMC)){
            nati=new NativeDMCDomain();
            nati.setNTDomain( request.getParameter("winDomain") );                
            username=request.getParameter("dmcUsername");
            password=request.getParameter("_dmcPassword");
            addType="win";
        }else if(type.equals(NativeDomain.NATIVE_ADS)){
            nati=new NativeADSDomain();
            ((NativeADSDomain)nati).setNTDomain(request.getParameter("winDomain"));
            String dnsDomain = request.getParameter("dnsDomain");
            String kdcServer = request.getParameter("kdcServer");
            
            //use the dnsDomain as kdcServer, when the kdcServer is not specifed
            if (kdcServer == null || kdcServer.trim().equals("")){
                kdcServer = dnsDomain;
            }
            if (dnsDomain != null){
                dnsDomain = dnsDomain.toUpperCase();
            }
            ((NativeADSDomain)nati).setDNSDomain(dnsDomain);
            ((NativeADSDomain)nati).setKDCServer(kdcServer);
            username=request.getParameter("adsUsername");
            password=request.getParameter("_adsPassword");
            addType="win";
        }else if (type.equals(NativeDomain.NATIVE_SHR)){
            nati=new NativeSHRDomain();
            nati.setNTDomain( request.getParameter("winDomain") );
            addType="win";
        }
        
        try{
            MapdCommon.addNative(session, nati,username,password,target);
        }catch (NSException ex){
            String forward="mapdnative.jsp?commonType=" + type + "&addType=" + addType;
            String alertMsg = MapdCommon.getNativeAlertMsg(session, ex.getErrorCode(),type);
            if (alertMsg!=null){
                super.setMsg(alertMsg);
                super.response.sendRedirect(super.response.encodeRedirectURL(forward));
                return;
            }else {
                throw ex;
            }
        }   
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        super.response.sendRedirect(super.response.encodeRedirectURL("nativelist.jsp?target="+target));
    }

    private void ldapInfo(NativeLDAPDomain nati)throws Exception {
        if (nati instanceof NativeLDAPUDomain){
            nati.setNetwork(request.getParameter("network") );
        }else{
            nati.setNTDomain( request.getParameter("winDomain") + "+" + request.getParameter("netbiosName") ); 
        }
        nati.setServerName(
            request.getParameter("ldapServer")
        );
        nati.setDistinguishedName(
            request.getParameter("ldapId")
        );
        nati.setTLS(
            request.getParameter("ldapTls")
        );
        nati.setAuthenticateType(request.getParameter("ldapMode"));
        nati.setUserFilter(request.getParameter("ldapUserFilter"));
        nati.setGroupFilter(request.getParameter("ldapGroupFilter"));
        if (!nati.getAuthenticateType().equals(NativeLDAPDomain.TYPE_ANON)){
            nati.setAuthenticateID(
                request.getParameter("ldapAuthName")
            );
            nati.setAuthenticatePasswd(
                request.getParameter("_ldapAuthPassword")
            );
        }                
        nati.setCAType(
            request.getParameter("ldapCa")
        );
        if( nati.getCAType().equals(AuthLDAPDomain.CATYPE_FILE) ){
            nati.setCA(
                request.getParameter("ldapCaFileText")
            );
        }else if( nati.getCAType().equals(AuthLDAPDomain.CATYPE_DIR) ){
            nati.setCA(
                request.getParameter("ldapCaDirText")
            );
        }
        nati.setUtoa(request.getParameter("utoa"));
    }
    
    public AuthInfo getLDAPInfo() throws Exception {
        return MapdCommon.getLDAPInfo(target);
    }
    
    public String getHasLdapSam()throws Exception {
        if(hasLdapSam == null){
            hasLdapSam = MapdCommon.getHasLdapSam(target);
        }
        return hasLdapSam;
    }

}