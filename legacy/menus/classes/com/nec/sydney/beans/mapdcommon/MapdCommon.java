/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.mapdcommon;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.atom.admin.ftp.*;
import com.nec.sydney.beans.ftp.*;
import com.nec.sydney.beans.mapd.MAPDSOAPClient;
import com.nec.sydney.atom.admin.nfs.NativeInfo;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.mapd.AuthInfoBaseBean;
import com.nec.sydney.beans.filesystem.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.beans.base.*;
import java.util.*;
import javax.servlet.http.*;


public class MapdCommon implements NasConstants,NSExceptionMsg
{
    private static final String     cvsid = "@(#) $Id: MapdCommon.java,v 1.2319 2007/04/27 05:07:57 wanghb Exp $";

    public static final String DIRECT_MOUNT="-d";
    public static final String SUB_MOUNT="-p";
    public static final String REAL_SUB_MOUNT="-s";
    public static final String FIND_EXPORTROOT="-e";
    public static final String QUOTA_MOUNT = "-q";
    public static final String DIR_QUOTA_MOUNT = "-dq";
    public static final String SNAP_MOUNT = "-snap";
    public static final String GLOBALDOMAIN = "DEFAULT";
    //constructor
    public MapdCommon(){}

    public static String getLocalDomain(HttpSession session, String target,String exportRoot)throws Exception
    {
        return getLocalDomain(session,target,exportRoot,null);
    }
    
    private static String getLocalDomain(HttpSession session, String target,String exportRoot,String groupNo)throws Exception
    {
        if (target==null||exportRoot==null){
            NSException ex = new NSException(MapdCommon.class,NSMessageDriver.getInstance().getMessage(session,"exception/common/invalid_param"));
            ex.setDetail("target="+target+",exportRoot="+exportRoot);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        LocalDomain localDomain;
        if (groupNo==null){
            localDomain = APISOAPClient.getLocalDomainInfo(target, exportRoot);
        }else{
            localDomain = APISOAPClient.getLocalDomainInfo(target, exportRoot, groupNo);
        }
        
        if(localDomain.isNull()){
            return null;
        }

        return localDomain.getLocalDomainName();
    }

    public static void deleteLocalDomain(HttpSession session,String exportRoot, String target)throws Exception{
        if (exportRoot==null||target==null){
            NSException ex = new NSException(MapdCommon.class,NSMessageDriver.getInstance().getMessage(session,"exception/common/invalid_param"));
            ex.setDetail("target="+target+",exportRoot="+exportRoot);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }

        // ims_native -d and ims_domain -d
        LocalDomain localDomain = 
            APISOAPClient.getLocalDomainInfo(target, exportRoot);
        if(localDomain==null||localDomain.isNull()){
            return;
        }

        String localDomainName=localDomain.getLocalDomainName();
        
        //del clientdomain when deleting localdomain with usermode
        List netbiosList = localDomain.getNetbios();
        if (netbiosList != null && netbiosList.size() != 0){
            String netbios = (String)netbiosList.get(0);
            delNative(localDomainName, netbios, target);
        }

        String hasNativeDomain = Boolean.toString(hasDMCNative(localDomainName,target)
            || hasADSNative(localDomainName,target));
        MapdCommonSOAPClient.deleteConf(exportRoot,localDomainName,hasNativeDomain,target);

        }//end function "deleteLocalDomain"

    public static boolean hasDMCNative(String localDomainName, String target)throws Exception{
        
        NativeDomain nativeDomain = APISOAPClient.getNativeDomain(target,localDomainName,"win");
        if (nativeDomain != null&& (nativeDomain instanceof NativeDMCDomain)){
            return true;
        }
        return false;
    }

    public static boolean hasADSNative(String localDomainName, String target)throws Exception{
        
        NativeDomain nativeDomain = APISOAPClient.getNativeDomain(target,localDomainName,"win");
        if (nativeDomain != null&& (nativeDomain instanceof NativeADSDomain)){
            return true;
        }
        return false;
    }

    public static boolean hasSHRNative(String localDomainName, String target)throws Exception{
    
        NativeDomain nativeDomain = APISOAPClient.getNativeDomain(target,localDomainName,"win");
        if (nativeDomain != null && (nativeDomain instanceof NativeSHRDomain)){
            return true;
        }
        return false;
    }

    public static boolean hasPWDOrNISNative(String target) throws Exception {

        List nativelist = APISOAPClient.getNativeList(target);
        Iterator itr = nativelist.iterator();
        while(itr.hasNext()){
            NativeDomain nativeDomain = (NativeDomain)itr.next();
/*            
            if ( nativeDomain instanceof NativePWDDomain
                    || nativeDomain instanceof NativeNISDomain  ){
                return true;
            }
*/
/*kanai's bug*/

            if( nativeDomain instanceof NativePWDDomain){
                if(!(nativeDomain instanceof NativePWDDomain4Win)){
                    return true;
                }
            }
            
            if( nativeDomain instanceof NativeNISDomain){
                if(!(nativeDomain instanceof NativeNISDomain4Win)){
                    return true;
                }
            }
            
            if(nativeDomain  instanceof NativeLDAPUDomain){
                    return true;
            }
            
        }
        return false;
    }

    public static void deleteAuthDomain(HttpSession session, String exportRoot,String authType, String target)throws Exception{
        if (authType==null||target==null){
            NSException ex = new NSException(MapdCommon.class,NSMessageDriver.getInstance().getMessage(session,"exception/common/invalid_param"));
            ex.setDetail("target="+target+",authType="+authType);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        String region;
        AuthDomain auth = 
            APISOAPClient.getAuthDomainByKind(target, exportRoot, authType);
        if (auth == null){
            return;
        }
        region = auth.getRegion();
        MapdCommonSOAPClient.deleteAuth(region,target);
        
        AuthInfo authInfo = new AuthInfo();
        authInfo.setExportRoot(exportRoot);
        authInfo.setAuthType(authType);
              

        if( authType.equals(AuthDomain.AUTH_NISW)
                || authType.equals(AuthDomain.AUTH_NIS) ){
            MapdCommon.delYPConf(target,(AuthNISDomain)auth);            
        } 
        
        //if is LDAP,when there are no ldu domain, close the IPtables.
        if (authType.equals(AuthDomain.AUTH_LDAPU)
                || authType.equals(AuthDomain.AUTH_LDAPUW)){
            
            String ldapServer ;
            try{
                ldapServer = getLDAPInfo(target).getServerName();
            }catch (Exception e){
                return;
            }
            MapdCommonSOAPClient.delIPTable(ldapServer,target);
            
            String friendnode=Soap4Cluster.whoIsMyFriend(target);
            if(friendnode!=null){
                MapdCommonSOAPClient.delIPTable(ldapServer,friendnode);
            }
        }      
    }//end function "deleteAuth"

    public static Vector getMountList(String path,String shift,String target)throws Exception{
        Vector mountList;
        //if(true)
        //    throw new Exception(path+" "+shift+" "+target);
        mountList=MapdCommonSOAPClient.getDirectMP(path,shift,target);
        return mountList;
    }

    public static boolean isSubMount(String path,String shift,String target)throws Exception{
        boolean isSubMount;
        isSubMount=MapdCommonSOAPClient.isSubMount(path,shift,target);
        return isSubMount;
    }
    // +++++++++++++++++++++++ getHasAuth ++++++++++++++++++++++++++++++
    public static boolean getHasAuth (String path,String export,String target) throws Exception
    {
        String region = getRegionWithAuth(path,export,target);
        if(region.equals(""))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public static String getRegionWithAuth(String path,String export,String target)throws Exception
    {
        String region = MAPDSOAPClient.getAuthRegion(target,path);
        if(region == null || region.trim().equals("")){
            return "";
        }else{
            return region;
        }
    }

    public static boolean  checkExportAuthbyKind(String exportroot,String kind,String target) throws Exception{
        AuthDomain auth = 
            APISOAPClient.getAuthDomainByKind(target, exportroot, kind);
        if (auth==null){
            return false;
        }else{
            return true;
        }

    }

    public static void checkNIS(HttpSession session,
                                String target,
                                String region,
                                String server,
                                String domain,
                                AuthNISDomain auth) throws Exception{
        auth.setDomainName(domain);
        auth.setDomainServer(server);
        auth.setRegion(region);

        boolean result = APISOAPClient.checkNISDomain(target, auth);

        if (!result){
            NSException ex = new NSException(MapdCommon.class, NSMessageDriver.getInstance().getMessage(session,"exception/mapd/authdomain_same"));
            ex.setDetail(NSMessageDriver.getInstance().getMessage(session,"exception/mapd/authdomain_same"));
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_MAPD_NIS_EXIST_FAILED);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
    }

    public static String  getAuthRegionByType(String target,String exportroot,String authtype) throws Exception
    {
        String authregion;
        AuthDomain authdomain = 
            APISOAPClient.getAuthDomainByKind(target, exportroot, authtype);
        if (authdomain==null)
        {
            authregion="";
            return authregion;
        }else{
                authregion=authdomain.getRegion();
                return authregion;
        }
    }

    public static String getEncoding(String target,String exportRootPath) throws Exception{       
        return getEncoding(target,exportRootPath,null);
    }
    
    public static String getEncoding(String target,String exportRootPath,String groupNo) throws Exception{       
        String code;
        if (groupNo==null){
            code = APISOAPClient.getCodepage(target, exportRootPath);
        }else{
            code = APISOAPClient.getCodepage(target, exportRootPath, groupNo);
        }
        return code;
    }

    public static void addNative(HttpSession session, NativeDomain nati,String target)throws Exception {
        addNative(session, nati,"","",target);
    }

    public static void addNative(HttpSession session,
                                 NativeDomain nati,
                                 String username,
                                 String password,
                                 String target)throws Exception {
        addNativeByNode(session, nati, username, password, target, false);
        try{
            String friendnode=Soap4Cluster.whoIsMyFriend(target);
            if(friendnode!=null)
                addNativeByNode(session, nati, username, password, friendnode, true);
        }catch(Exception e){
            NSReporter.getInstance().report(NSReporter.DEBUG, "FriendNode Error: "+e.toString());

        }

    }
    private static void addNativeByNode(HttpSession session,
                                        NativeDomain nati,
                                        String username,
                                        String password,
                                        String target,
                                        boolean isFriend)throws Exception {
            //[1]xml : check
        NativeInfo nativeInfo = new NativeInfo();
        nativeInfo.setExportRoot(".");
        boolean result = false;
        boolean bADSCheckout = false;
  
        NativeDomain ldapDomain4replace = new NativeLDAPUDomain();
        if(nati instanceof NativeNISDomain4Win){

            result = APISOAPClient.checkNativeDomain(target,nati.getNTDomain(),"win");

            nativeInfo.setType(NativeDomain.NATIVE_NISW);

            nativeInfo.setNetBios( ((NativeNISDomain4Win)nati).getNetbios() );
            nativeInfo.setDomain( ((NativeNISDomain4Win)nati).getNTDomain() );
            nativeInfo.setNisDomain( ((NativeNISDomain4Win)nati).getDomainName() );
            nativeInfo.setServer( ((NativeNISDomain4Win)nati).getDomainServer() );

        }else if(nati instanceof NativePWDDomain4Win){

            result = APISOAPClient.checkNativeDomain(target,nati.getNTDomain(),"win");

            nativeInfo.setType(NativeDomain.NATIVE_PWDW);
 
            String pass = new String(((NativePWDDomain4Win)nati).getPasswd());
            String [] sa = pass.split("/");
            String ludbName = sa[sa.length - 2];
            
            String grp = "";
            if (isFriend){
                pass = mergePwd("","sxfsfw",ludbName,"/passwd",target);
                grp = mergePwd("","sxfsfw",ludbName,"/group",target);
                ((NativePWDDomain4Win)nati).setPasswd(pass.getBytes());
                ((NativePWDDomain4Win)nati).setGroup(grp.getBytes());
            }else{
                grp = new String(((NativePWDDomain4Win)nati).getGroup());
            }
            nativeInfo.setLUDB(ludbName);
            nativeInfo.setNetBios( ((NativePWDDomain4Win)nati).getNetbios() );
            nativeInfo.setDomain( ((NativePWDDomain4Win)nati).getNTDomain() );
            nativeInfo.setGroup( grp );
            nativeInfo.setPath( pass);

        }else if(nati instanceof NativeLDAPUDomain4Win){

            //result=ninfo.checkNativeDomain((NativeLDAPUDomain4Win)nati);
            nativeInfo.setType(NativeDomain.NATIVE_LDAPUW);

            NativeLDAPUDomain4Win n = (NativeLDAPUDomain4Win)nati;
            
            nativeInfo.setNetBios(n.getNetbios() );
            nativeInfo.setDomain(n.getNTDomain() );
            nativeInfo.setServerName(n.getServerName());
            nativeInfo.setDistinguishedName(n.getDistinguishedName());
            nativeInfo.setAuthenticateType(n.getAuthenticateType());
            nativeInfo.setTLS(n.getTLS());
            nativeInfo.setAuthenticateID(n.getAuthenticateID());
            nativeInfo.setAuthenticatePasswd(n.getAuthenticatePasswd());
            nativeInfo.setCAType(n.getCAType());
            nativeInfo.setCA(n.getCA());
            nativeInfo.setUserFilter(n.getUserFilter());
            nativeInfo.setGroupFilter(n.getGroupFilter());
            nativeInfo.setUtoa(n.getUtoa());
            ldapDomain4replace = nati;
            nati = new NativeLDAPUDomain4Win();
            nati.setNTDomain(((NativeLDAPUDomain4Win)ldapDomain4replace).getNTDomain());
            result=APISOAPClient.checkNativeDomain(target,nati.getNTDomain(),"win");
            /*
            ((NativeLDAPDomain)nati).setServerName("");
            ((NativeLDAPDomain)nati).setDistinguishedName("");
            ((NativeLDAPDomain)nati).setAuthenticateType("");
            ((NativeLDAPDomain)nati).setTLS("");
            ((NativeLDAPDomain)nati).setAuthenticateID("");
            ((NativeLDAPDomain)nati).setAuthenticatePasswd("");
            ((NativeLDAPDomain)nati).setCAType("");
            ((NativeLDAPDomain)nati).setCA("");
            */
            if (!isFriend && !result){
                setLDAPInfo(nativeInfo,target);
            }

        }else if(nati instanceof NativeDMCDomain){

            result=APISOAPClient.checkNativeDomain(target,nati.getNTDomain(),"win");

            nativeInfo.setType(NativeDomain.NATIVE_DMC);
            nativeInfo.setDomain( ((NativeDMCDomain)nati).getNTDomain() );            

        }else if(nati instanceof NativeADSDomain){
            String ntDomain = nati.getNTDomain();
            result=APISOAPClient.checkNativeDomain(target, ntDomain, "win");
            String dnsDomain = ((NativeADSDomain)nati).getDNSDomain();
            String kdcServer = ((NativeADSDomain)nati).getKDCServer();            
            nativeInfo.setType(NativeDomain.NATIVE_ADS);
            nativeInfo.setDomain(ntDomain);
            nativeInfo.setDNSDomain(dnsDomain);
            nativeInfo.setKDCServer(kdcServer);
            if (!isFriend && !result){
                MapdCommon.checkoutADSFiles(target, ntDomain);
                bADSCheckout = true;
                try{
                    MapdCommon.setADSConf(
                        target, ntDomain, dnsDomain, kdcServer);
                }catch (Exception e){
                    MapdCommon.rollbackADSFiles(target, ntDomain);
                    throw e;
                }
            }
        }else if(nati instanceof NativeSHRDomain){

            result=APISOAPClient.checkNativeDomain(target,nati.getNTDomain(),"win");

            nativeInfo.setType(NativeDomain.NATIVE_SHR);
            nativeInfo.setDomain( ((NativeSHRDomain)nati).getNTDomain() );

        }else if(nati instanceof NativeNISDomain){

            result=APISOAPClient.checkNativeDomain(target,nati.getNetwork(),"unix");

            nativeInfo.setType(NativeDomain.NATIVE_NIS);
            nativeInfo.setEffcNetwork( ((NativeNISDomain)nati).getNetwork() );
            nativeInfo.setNisDomain( ((NativeNISDomain)nati).getDomainName() );
            nativeInfo.setServer( ((NativeNISDomain)nati).getDomainServer() );

        }else if(nati instanceof NativePWDDomain){

            result=APISOAPClient.checkNativeDomain(target,nati.getNetwork(),"unix");

            nativeInfo.setType(NativeDomain.NATIVE_PWD);
            nativeInfo.setEffcNetwork( ((NativePWDDomain)nati).getNetwork() );

            String pass = new String(((NativePWDDomain)nati).getPasswd());
            String [] sa = pass.split("/");
            String ludbName = sa[sa.length - 2];
            
            String grp = "";
            if (isFriend){
                pass = mergePwd("","sxfs",ludbName,"/passwd",target);
                grp = mergePwd("","sxfs",ludbName,"/group",target);
                ((NativePWDDomain)nati).setPasswd(pass.getBytes());
                ((NativePWDDomain)nati).setGroup(grp.getBytes());
            }else{
                pass = new String(((NativePWDDomain)nati).getPasswd());
                grp = new String(((NativePWDDomain)nati).getGroup());
            }
            
            nativeInfo.setGroup(grp);
            nativeInfo.setPath(pass);

        }else if(nati instanceof NativeLDAPUDomain){

            
            nativeInfo.setType(NativeDomain.NATIVE_LDAPU);

            NativeLDAPUDomain n=(NativeLDAPUDomain)nati;
            
            nativeInfo.setEffcNetwork(n.getNetwork());
            nativeInfo.setServerName(n.getServerName());
            nativeInfo.setDistinguishedName(n.getDistinguishedName());
            nativeInfo.setCAType(n.getCAType());
            nativeInfo.setAuthenticateType(n.getAuthenticateType());
            nativeInfo.setTLS(n.getTLS());
            nativeInfo.setAuthenticateID(n.getAuthenticateID());
            nativeInfo.setAuthenticatePasswd(n.getAuthenticatePasswd());
            nativeInfo.setCA(n.getCA());
            nativeInfo.setUserFilter(n.getUserFilter());
            nativeInfo.setGroupFilter(n.getGroupFilter());
            nativeInfo.setUtoa(n.getUtoa());
            ldapDomain4replace = nati;
            nati = new NativeLDAPUDomain();
            nati.setNetwork(((NativeLDAPUDomain)ldapDomain4replace).getNetwork());
            result=APISOAPClient.checkNativeDomain(target,nati.getNetwork(),"unix");
            /*
           ((NativeLDAPDomain)nati).setServerName("");
           ((NativeLDAPDomain)nati).setDistinguishedName("");
           ((NativeLDAPDomain)nati).setAuthenticateType("");
           ((NativeLDAPDomain)nati).setTLS("");
           ((NativeLDAPDomain)nati).setAuthenticateID("");
           ((NativeLDAPDomain)nati).setAuthenticatePasswd("");
           ((NativeLDAPDomain)nati).setCAType("");
           ((NativeLDAPDomain)nati).setCA("");
            */
            
            if (!isFriend && !result){
                setLDAPInfo(nativeInfo,target);
            }
        }
     
        if(!result){
            if (nati instanceof NativeNISDomain &&
                        !APISOAPClient.checkNISDomain(target,nati)) {
                    NSException ex = new NSException(MapdCommon.class,
                        NSMessageDriver.getInstance().getMessage(session, "exception/mapd/addxmlfailed"));
                    ex.setDetail(NSMessageDriver.getInstance().getMessage(session, "exception/mapd/authdomain_same"));
                    ex.setReportLevel(NSReporter.ERROR);
                    ex.setErrorCode(NAS_EXCEP_NO_MAPD_NIS_EXIST_FAILED);
                    NSReporter.getInstance().report(ex);
                    throw ex;
            }
        }else{
            NSException ex = new NSException(MapdCommon.class,NSMessageDriver.getInstance().getMessage(session, "exception/nfs/some_err"));
            ex.setDetail(NSMessageDriver.getInstance().getMessage(session , "exception/nfs/some_err"));
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_NFS_XML_CHECK_SYNC_FAILED);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        try{
            if(!isFriend){
                if(nati instanceof NativeADSDomain && !username.equals("") ){
                    MapdCommonSOAPClient.joinDomain(target, NativeDomain.NATIVE_ADS, 
                        nativeInfo.getDomain(), username, password,"",((NativeADSDomain)nati).getDNSDomain());
                }
                if(nati instanceof NativeDMCDomain && !username.equals("") ){
                    MapdCommonSOAPClient.joinDomain(target, NativeDomain.NATIVE_DMC, 
                        nativeInfo.getDomain(), username, password, "", "");
                }
            }
            //[2]server : add
            String region = MAPDSOAPClient.addNative(target,nativeInfo,(isFriend ? "false":"true"));
            nati.setRegion(region);
            if (bADSCheckout){
                bADSCheckout = false;
                MapdCommon.checkinADSFiles(target, nati.getNTDomain());
            }
        }catch (Exception e){
            if (bADSCheckout){
                MapdCommon.rollbackADSFiles(target, nati.getNTDomain());
            }
            throw e;
        }

        
        if(nati instanceof NativeLDAPUDomain4Win
            || nati instanceof NativeLDAPUDomain){
                nati = ldapDomain4replace;
        }
    }

    /**
     *  If addNative() failed, return alert msg.
     */
    public static String getNativeAlertMsg(HttpSession session ,int errorCode,String nativeType){
            String errorMsg="";
            if (errorCode==NAS_EXCEP_INVALID_NETWORK){
                return NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session,"nas_native/alert/errorIp");
            }else if (errorCode==NAS_EXCEP_NO_NFS_EXEC_IMS_DOMAIN
                        || errorCode==NAS_EXCEP_NO_NFS_EXEC_IMS_NATIVE )  {
                return NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+"\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, "exception/nfs/msg_seterr");
                //it maybe useless
            }else if (errorCode==NAS_EXCEP_NO_MAPD_NIS_SERVER_FAILED ){
                return NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+"\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, "nas_mapd/alert/nis_server_failed");
            }else if (errorCode==NAS_EXCEP_NO_NFS_XML_CHECK_SYNC_FAILED ){

                if(nativeType.equals(NativeDomain.NATIVE_NIS)
                    ||nativeType.equals(NativeDomain.NATIVE_PWD)
                    ||nativeType.equals(NativeDomain.NATIVE_LDAPU)){
                    errorMsg=NSMessageDriver.getInstance().getMessage(session, "exception/nfs/same_err_nis");
                }else if(nativeType.equals(NativeDomain.NATIVE_DMC)
                          ||nativeType.equals(NativeDomain.NATIVE_ADS)
                          ||nativeType.equals(NativeDomain.NATIVE_SHR)
                          ||nativeType.equals(NativeDomain.NATIVE_LDAPUW)
                          ||nativeType.equals(NativeDomain.NATIVE_NISW)
                          ||nativeType.equals(NativeDomain.NATIVE_PWDW)){
                    errorMsg=NSMessageDriver.getInstance().getMessage(session, "exception/nfs/same_err_dmc");
                }
                return NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+"\\r\\n"+errorMsg;

            }else if (errorCode==NAS_EXCEP_NO_MAPD_DMC_SMBPASSWD_FAILED ){
                String msg = NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+"\\r\\n";
                if (nativeType.equals(NativeDomain.NATIVE_DMC)){
                    msg += NSMessageDriver.getInstance().getMessage(session, "nas_mapd/alert/dmc_passwd_failed");
                }else if (nativeType.equals(NativeDomain.NATIVE_ADS)){
                    msg += NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ads_passwd_failed");
                }
                return msg;
            }else if (errorCode==NAS_EXCEP_NO_MAPD_NIS_EXIST_FAILED){
                return NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                        + NSMessageDriver.getInstance().getMessage(session,"exception/mapd/authdomain_same");
            }else if (errorCode==NAS_EXCEP_NO_MAPD_LDAP_ADD_FAILED){
                return NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                        + NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ldapAddFail");
            }else {
                return null;
            }
    }

    public static void delYPConf(String target,AuthNISDomain auth)throws Exception{
        if(!isUsedNISDomain(target,auth.getDomainName())){
            //whether native or auth, single or cluster, it will count whole nases.xml.
            MapdCommonSOAPClient.delYPConf(auth.getDomainName(), auth.getDomainServer(), target);

            try{
                String targetnew=Soap4Cluster.whoIsMyFriend(target);
                if(targetnew!=null){
                    MapdCommonSOAPClient.delYPConf(auth.getDomainName(), auth.getDomainServer(), targetnew);
                }
            }catch(Exception e){
                NSReporter.getInstance().report(NSReporter.DEBUG, "rsync error: "+e.toString());
            }
        }
    }

    /**
     * To check if the specified mountpoint has been exported to \
     * NFS or CIFS client before delete filesystem or replica.
     * @param exportRootPath -> the root path of the mountpoint. eg: /export/nec
     * @param mountPointHex  -> the hex string of the mountpoint.
     * @param target         -> the url of the NAS node.         eg: hawk@NAS
     * @author wangzf@necas.nec.com.cn
     */
    public static int checkExport(String exportRootPath, String mountPointHex, String target) throws Exception {
        LocalDomain localDomain = 
            APISOAPClient.getLocalDomainInfo(target, exportRootPath);
        String localDomainName;
        String netbiosName;

        if(localDomain.isNull()) {
            localDomainName = "";
            netbiosName = "";
        } else {
            List netbiosList = localDomain.getNetbios();
            if(netbiosList == null || netbiosList.isEmpty()) {
                netbiosName = "";
            } else {
                netbiosName = (String)netbiosList.get(0);
            }
            localDomainName = localDomain.getLocalDomainName();
        }

        return MapdCommonSOAPClient.checkExport(exportRootPath, localDomainName,
                                                netbiosName, mountPointHex, target);
    }


     public static boolean checkPwd(String darn,
                                    String export,
                                    String filesystem,
                                    String back,
                                    String target) throws Exception {
        
        String root = MAPDSOAPClient.getLudbRoot(target);
        return checkPwd(darn,export,filesystem,back,target,root);
     }
     
     public static boolean checkPwd(String darn,String export,String filesystem,
                                    String back,String target,String root) throws Exception {
        String front="";
        
        front=root+"/.ludb/";
        if( darn.matches(front+"[^/]+"+back) ){
            return true;
        }

        return false;
     }

     public static String mergePwd(String export,
                                   String filesystem,
                                   String ludb,
                                   String back,
                                   String target) throws Exception {
        String root=MAPDSOAPClient.getLudbRoot(target);
        String darn="";
        
        darn=root+"/.ludb/"+ludb+back;
        return darn;
     }

     public static String trimPwd(String darn,
                                  String export,
                                  String filesystem,
                                  String target) throws Exception {
         String root=MAPDSOAPClient.getLudbRoot(target);
         return trimPwd(darn,export,filesystem,target,root);
     }
     
     public static String trimPwd(String darn,
                                  String export,
                                  String filesystem,
                                  String target,
                                  String root) throws Exception {
         String front="";
         front=root+"/.ludb/";
        
         darn=darn.substring(front.length());
         int pos=darn.indexOf("/");

         darn=darn.substring(0,pos);
         return darn;
     }

     public static void setAuthNIS(HttpSession session,
                                   HttpServletRequest request,
                                   AuthInfo auth,
                                   String target) throws Exception {

        MapdCommon.setAuthSession(session,auth);

        String region=auth.getRegion();
        boolean hasNIS=false;
        boolean hasAuth=auth.getHasAuth();
        if( (auth.getAuthType()).equals(AuthDomain.AUTH_NIS) ){
            hasNIS=auth.getHasNISU();
        }else{
            hasNIS=auth.getHasNISW();
        }
        if (!auth.isFromCIFS()){
            if( (auth.getAuthType()).equals(AuthDomain.AUTH_NIS)&&auth.getHasNISU()
                    ||(auth.getAuthType()).equals(AuthDomain.AUTH_NISW)&&auth.getHasNISW() ){

                AuthNISDomain nisDomain;
                AuthInfoBaseBean xx=new AuthInfoBaseBean();
                xx.setTarget(target);

                if( (auth.getAuthType()).equals(AuthDomain.AUTH_NISW) ){
                    nisDomain = (AuthNISDomain4Win)xx.getAuthByType(
                        (String)session.getAttribute(MP_SESSION_EXPORTROOT)
                        ,AuthDomain.AUTH_NISW);
                }else{
                    nisDomain = (AuthNISDomain)xx.getAuthByType(
                        (String)session.getAttribute(MP_SESSION_EXPORTROOT)
                        ,AuthDomain.AUTH_NIS);
                }

                auth.setDomain( nisDomain.getDomainName() );
                auth.setOldServer( nisDomain.getDomainServer() );
                auth.setServer( request.getParameter("nisServer") );
            }else{
                auth.setDomain( request.getParameter("nisDomain") );
                auth.setServer( request.getParameter("nisServer") );
            }
        }        
        auth.setNameChange(request.getParameter("nameChange"));

        AuthNISDomain nisdomain=new AuthNISDomain();
        AuthNISDomain4Win nisdomain4win= new AuthNISDomain4Win();
        if (hasNIS==false){
            if (auth.getAuthType().equals(AuthDomain.AUTH_NIS)){            
                MapdCommon.checkNIS(session, target,region,
                    auth.getServer(),auth.getDomain(),nisdomain);            
            }else{            
                MapdCommon.checkNIS(session, target,region,
                    auth.getServer(),auth.getDomain(),nisdomain4win);
            }            
        }        

        //Nis Server Name changed
        if (hasAuth==true&&auth.getNameChange().equals(REQUEST_PARAMETER_NAMECHANGE_VALUE)) {
            auth.setOldServer (request.getParameter(REQUEST_PARAMETER_FIRSTSERVER));
            MAPDSOAPClient.setAuthNISAgain(target ,auth);
        }else{
            if (hasAuth==false){
                auth.setOldServer (request.getParameter(REQUEST_PARAMETER_FIRSTSERVER));
                auth.setRegion(region);
                region=MAPDSOAPClient.setAuthNIS(target,auth);
            }
        }

        remoteSyncYPConf(target,auth.getDomain(),
                         auth.getServer(),auth.getOldServer());
     }

     public static void setAuthPWD(HttpSession session,
                                   HttpServletRequest request,
                                   AuthInfo auth,
                                   String target) throws Exception {

            MapdCommon.setAuthSession(session,auth);
            String ludb;
            if (!auth.isFromCIFS()){
                ludb=request.getParameter("pwdLudb");
                auth.setLUDB(ludb);
            }else{
                ludb=auth.getLUDB();
            }
            String pwdPath=mergePwd(auth.getExportRoot(),
                                    auth.getFileSystem(),
                                    ludb,"/passwd",
                                    target);

            String groupPath=mergePwd(auth.getExportRoot(),
                                      auth.getFileSystem(),
                                      ludb,"/group",
                                      target);
            pwdPath = NSUtil.ascii2hStr(pwdPath);
            groupPath = NSUtil.ascii2hStr(groupPath);
            auth.setPWDPath(pwdPath);
            auth.setGroupPath(groupPath);
            boolean hasPWD=false;
            if((auth.getAuthType()).equals(AuthDomain.AUTH_PWD)){
                hasPWD=auth.getHasPWDU();
                auth.setHasPWD(auth.getHasPWDU());
            }else{
                hasPWD=auth.getHasPWDW();
                auth.setHasPWD(auth.getHasPWDW());
            }
            String region="";
            
            if(auth.isFromCIFS()){
                region=MAPDSOAPClient.setAuthPWD4CIFS(target,auth);
            }else{                
                region=MAPDSOAPClient.setAuthPWD(target,auth);
            }
     }

     public static void setAuthLDAP(HttpSession session,
                                    HttpServletRequest request,
                                    AuthInfo auth,
                                    String target) throws Exception {

            MapdCommon.setAuthSession(session,auth);
            if (!auth.isFromCIFS()){
                if( (auth.getAuthType()).equals(AuthDomain.AUTH_LDAPU) ||(auth.getAuthType()).equals(AuthDomain.AUTH_LDAPUW)){
                    auth.setServerName(
                        request.getParameter("ldapServer")
                    );
                    auth.setDistinguishedName(
                        request.getParameter("ldapId")
                    );
                    auth.setAuthenticateType(
                        request.getParameter("ldapMode")
                    );
                    auth.setTLS(
                        request.getParameter("ldapTls")
                    );
                    auth.setUserFilter(request.getParameter("ldapUserFilter"));
                    auth.setGroupFilter(request.getParameter("ldapGroupFilter"));
                    if (!auth.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON)){
                        auth.setAuthenticateID(
                            request.getParameter("ldapAuthName")
                        );
                        auth.setAuthenticatePasswd(
                            request.getParameter("_ldapAuthPassword")
                        );                
                    }
                    auth.setCAType(
                        request.getParameter("ldapCa")
                    );
                    if(auth.getCAType().equals(AuthLDAPDomain.CATYPE_FILE)){
                        auth.setCA(
                            request.getParameter("ldapCaFileText")
                        );
                    }else if(auth.getCAType().equals(AuthLDAPDomain.CATYPE_DIR)){
                        auth.setCA(
                            request.getParameter("ldapCaDirText")
                        );
                    }
                }
            }

            boolean hasLDAP=false;
            boolean hasAuth=auth.getHasAuth();
            if( (auth.getAuthType()).equals(AuthDomain.AUTH_LDAPU) ){
                hasLDAP=auth.getHasLDAPU();
            }else{
                hasLDAP=auth.getHasLDAPW();
            }
            setLDAPInfo(auth,target);
            if (!hasAuth){            
                String region=MAPDSOAPClient.setAuthLDAP(target,auth);
            }
     }

    public static void setAuthSession(HttpSession session,
                                      AuthInfo auth) throws Exception {

        String export=(String)session.getAttribute(MP_SESSION_EXPORTROOT);
        String mountpoint=(String)session.getAttribute(MP_SESSION_MOUNTPOINT);
        String hexPath=(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        String target=(String)session.getAttribute(TARGET);
        String type=auth.getAuthType();

        auth.setPath(hexPath);
        auth.setExportRoot(export);
        String region = MapdCommon.getAuthRegionByType(target,export,type);
        auth.setRegion(region);

        if(!auth.isFromCIFS()){
            auth.setHasAuth( MapdCommon.getHasAuth(hexPath,export,target) );
        }

        boolean exportHas = (region != null && !region.equals(""));

        if(type.equals(AuthDomain.AUTH_NIS)){
            auth.setHasNISU(exportHas);
        }else if (type.equals(AuthDomain.AUTH_NISW)){
            auth.setHasNISW(exportHas);
        }else if(type.equals(AuthDomain.AUTH_PWD)){
            auth.setFileSystem(FILETYPE_UNIX);
            auth.setHasPWDU(exportHas);
        }else if(type.equals(AuthDomain.AUTH_PWDW)){
            auth.setFileSystem(FILETYPE_NT);
            auth.setHasPWDW(exportHas);
        }else if(type.equals(AuthDomain.AUTH_SHR)){
            auth.setHasSHR(exportHas);
        }else if(type.equals(AuthDomain.AUTH_ADS)){
            auth.setHasADS(exportHas);
        }else if(type.equals(AuthDomain.AUTH_DMC)){
            auth.setHasDMC(exportHas);
        }else if(type.equals(AuthDomain.AUTH_LDAPU)){
            auth.setHasLDAPU(exportHas);
        }else if(type.equals(AuthDomain.AUTH_LDAPUW)){
            auth.setHasLDAPW(exportHas);
        }
    }

    public static void unsetAuth(HttpSession session,
                                 HttpServletRequest request,                                 
                                 String target) throws Exception {

        String authDomainType=request.getParameter("commonType");
        String hexPath=(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        String region = MAPDSOAPClient.getAuthRegion(target,hexPath);
        String exportroot=(String)session.getAttribute(MP_SESSION_EXPORTROOT);

        AuthInfo authInfo=new AuthInfo();
        authInfo.setAuthType(authDomainType);        
        authInfo.setPath(hexPath);
        authInfo.setExportRoot(exportroot);
        setAuthSession(session,authInfo);

        SoapRpsBoolean rpsBoolean = MapdCommonSOAPClient.delAuth(hexPath,region,target);

        if (!rpsBoolean.isSuccessful()){
            NSException ex = new NSException
                (MapdCommon.class,NSMessageDriver.getInstance().getMessage(session,
                "exception/common/soap_call"));
            ex.setDetail(rpsBoolean.getErrorMessage());
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(rpsBoolean.getErrorCode());
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        
        if(rpsBoolean.getBoolean()){
            deleteAuthDomain(session, exportroot,authDomainType,target);
        }
    }

    // just for get  Native (NISW/PWDW/LDAPW)
    public static NativeDomain getNativeDomain(String domAndBios, String target) throws Exception{
       
        NativeDomain nativeDomain = APISOAPClient.getNativeDomain(target,domAndBios,"win");
        if (nativeDomain == null){
            return null;
        }
        if (nativeDomain instanceof NativeLDAPUDomain4Win){
            AuthInfo ldapInfo = getLDAPInfo(target);
            if (ldapInfo == null){
                return null;
            }
            ((NativeLDAPUDomain4Win)nativeDomain).setServerName(ldapInfo.getServerName());
            ((NativeLDAPUDomain4Win)nativeDomain).setDistinguishedName(ldapInfo.getDistinguishedName());
            ((NativeLDAPUDomain4Win)nativeDomain).setAuthenticateType(ldapInfo.getAuthenticateType());
            ((NativeLDAPUDomain4Win)nativeDomain).setTLS(ldapInfo.getTLS());
            ((NativeLDAPUDomain4Win)nativeDomain).setUserFilter(ldapInfo.getUserFilter());
            ((NativeLDAPUDomain4Win)nativeDomain).setGroupFilter(ldapInfo.getGroupFilter());
            ((NativeLDAPUDomain4Win)nativeDomain).setAuthenticateID(ldapInfo.getAuthenticateID());
            ((NativeLDAPUDomain4Win)nativeDomain).setAuthenticatePasswd(
            ldapInfo.getAuthenticatePasswd());
            ((NativeLDAPUDomain4Win)nativeDomain).setCA(ldapInfo.getCA());
            ((NativeLDAPUDomain4Win)nativeDomain).setCAType(ldapInfo.getCAType());
       }
        return nativeDomain;
             
    }

    public static String getFriendRegion( String friendnode, String type, String network)throws Exception{
        
        List nativelist = APISOAPClient.getNativeList(friendnode);
        NativeDomain nati = null;
        Iterator it=nativelist.iterator();
        while(it.hasNext()){
            nati=(NativeDomain)it.next();            

            if (type.equals(NativeDomain.NATIVE_NIS)
                ||type.equals(NativeDomain.NATIVE_PWD)
                ||type.equals(NativeDomain.NATIVE_LDAPU) ){

                    if (((nati instanceof NativeNISDomain)
                          && !(nati instanceof NativeNISDomain4Win))
                        ||((nati instanceof NativePWDDomain)
                          && !(nati instanceof NativePWDDomain4Win))
                        ||(nati instanceof NativeLDAPUDomain)){
                            if ((nati.getNetwork()).equals(network)){
                                return nati.getRegion();
                            }
                    }
            }else if (type.equals(NativeDomain.NATIVE_SHR)
                     ||type.equals(NativeDomain.NATIVE_DMC)
                     ||type.equals(NativeDomain.NATIVE_ADS)
                     ||type.equals(NativeDomain.NATIVE_PWDW)
                     ||type.equals(NativeDomain.NATIVE_NISW)
                     ||type.equals(NativeDomain.NATIVE_LDAPUW)){

                    if ((nati instanceof NativeSHRDomain)
                        ||(nati instanceof NativeDMCDomain)
                        ||(nati instanceof NativeADSDomain)
                        ||(nati instanceof NativeNISDomain4Win)
                        ||(nati instanceof NativePWDDomain4Win)
                        ||(nati instanceof NativeLDAPUDomain4Win)){
                            if ((nati.getNTDomain()).equals(network)){
                                return nati.getRegion();
                            }
                    }
            }
        }
        return "";//It will cause exception in Upper function, but it will be catched.
    }
    
    //del user mode native when del netbios or localdomain  (just for CIFS)
    public static void delNative(String domainname, String biosname, String target)throws Exception{
        String domAndBios = domainname + "+" + biosname;
        NativeDomain nati = getNativeDomain(domAndBios,target);
        String type;
        String friendnode=Soap4Cluster.whoIsMyFriend(target); 

        if(nati instanceof NativeNISDomain4Win){            
            type=NativeDomain.NATIVE_NISW;
        }else if(nati instanceof NativePWDDomain4Win){
            type=NativeDomain.NATIVE_PWDW;
            
            String pwdFile = new String(
                ((NativePWDDomain4Win)nati).getPasswd());
            String [] sa = pwdFile.split("/");
            //get ludbName from ..../[ludbname]/passwd
            String ludb = sa[sa.length - 2];
            MAPDSOAPClient.rmsmbpasswd(domainname,biosname,ludb,target);

            if(friendnode!=null){
                MAPDSOAPClient.rmsmbpasswd(domainname,biosname,ludb,friendnode);
            }           
            
        }else if(nati instanceof NativeLDAPUDomain4Win){            
            type=NativeDomain.NATIVE_LDAPUW;
        }else{
            return;
        }
        
        //String region = getFriendRegion(target, type, domAndBios);
        String region = nati.getRegion();
        deleteNativeByNode(target, type, region, domAndBios);

        if(friendnode!=null){
            String friendRegion = getFriendRegion(friendnode,type,domAndBios);
            deleteNativeByNode(friendnode,type,friendRegion,domAndBios);
        }
        
        if (type.equals(NativeDomain.NATIVE_LDAPU)
                || type.equals(NativeDomain.NATIVE_LDAPUW)){
            String ldapServer;
            try{
                ldapServer = getLDAPInfo(target).getServerName();
            }catch (Exception e){
                return;
            }
            MapdCommonSOAPClient.delIPTable(ldapServer,target);
            
            if(friendnode!=null){
                MapdCommonSOAPClient.delIPTable(ldapServer,friendnode);
            }
        }
        
        if(nati instanceof NativeNISDomain4Win){            
            String domain=((NativeNISDomain4Win)nati).getDomainName();
            String server=((NativeNISDomain4Win)nati).getDomainServer();

            if(!isUsedNISDomain(target, domain)){
                //whether native or auth, single or cluster, it will count whole nases.xml.
                MapdCommonSOAPClient.delYPConf( domain,server,target );
                if(friendnode!=null){
                    MapdCommonSOAPClient.delYPConf( domain,server,friendnode );
                }
            }
        }

    }

    public static void deleteNativeByNode(  String node,
                                            String type,
                                            String region,
                                            String network)throws Exception {

        //[1-1]server : ims_native
        MAPDSOAPClient.delNative(node,type,network,region);
        try{
            //[1-2]server : ims_domain
            MAPDSOAPClient.setMapdDelete(node,region);
        }catch(NSException ns){
            //Continue even exception occured
        }
         //[3]server : delete the NT Domain directory
        if ( type.equals(NativeDomain.NATIVE_DMC) 
            || type.equals(NativeDomain.NATIVE_ADS)){
            //the value of network is ntdomain.
            MapdCommonSOAPClient.deleteConf("",network,"false",node);
        }
    }

    public static void remoteSyncYPConf (String target,String domain,
                                         String server,String oldserver) throws Exception
    {
        try
        {
            String targetnew=Soap4Cluster.whoIsMyFriend(target);
            if (oldserver == null){
                oldserver = "";
            }
            if(targetnew!=null)
                MAPDSOAPClient.remoteSyncYPConf(domain,server,oldserver,targetnew);
        }
        catch(Exception e)
        {
            NSReporter.getInstance().report(NSReporter.DEBUG, "rsync error: "+e.toString());
        }
    }

    public static AuthInfo getLDAPInfo(String target) throws Exception{
        return getLDAPInfo(target,null);
    }
    
    public static AuthInfo getLDAPInfo(String target, String groupNo) throws Exception{
       FTPAuthInfo ftpAuthInfo = null;
       if (groupNo==null){
            ftpAuthInfo = FTPSOAPClient.getAuthInfo(target,"0");
       }else{
            ftpAuthInfo = FTPSOAPClient.getAuthInfo(target,"0",groupNo);
       }

       if (ftpAuthInfo == null
           || ftpAuthInfo.getLdapServer() == null 
           || ftpAuthInfo.getLdapServer().equals("")){
           return null;
       }
       AuthInfo ldap = new AuthInfo();
       ldap.setServerName(ftpAuthInfo.getLdapServer());
       ldap.setDistinguishedName(ftpAuthInfo.getLdapBaseDN());
       ldap.setAuthenticateType(ftpAuthInfo.getLdapMethod());
       ldap.setTLS(ftpAuthInfo.getLdapUseTls());
       ldap.setAuthenticateID(ftpAuthInfo.getLdapBindName());
       ldap.setAuthenticatePasswd(ftpAuthInfo.getLdapBindPasswd());
       ldap.setUserFilter(ftpAuthInfo.getUserFilter());
       ldap.setGroupFilter(ftpAuthInfo.getGroupFilter());
       ldap.setUtoa(ftpAuthInfo.getUtoa());
       if (!ftpAuthInfo.getLdapCertFile().equals("")){
           ldap.setCA(ftpAuthInfo.getLdapCertFile());
           ldap.setCAType("file");
       }else if (!ftpAuthInfo.getLdapCertDir().equals("")){
           ldap.setCA(ftpAuthInfo.getLdapCertDir());
           ldap.setCAType("dir");
       }else{
           ldap.setCA("");
           ldap.setCAType("no");
       }

       return ldap;
    }

    public static void setLDAPInfo(Object obj, String target) throws Exception{
        //AuthInfo ldap = getLDAPInfo(target);
        //if (ldap != null && compareLDAPInfo(obj,ldap)){
            //return;
        //}
        MapdCommonSOAPClient.setLDAPInfo(obj, target);
        //try{
            String friend = Soap4Cluster.whoIsMyFriend(target);
            if(friend != null)
                MapdCommonSOAPClient.setLDAPInfo(obj, friend);
        //}catch(Exception e){
        //    NSReporter.getInstance().report(NSReporter.DEBUG, 
        //        "rsync error: "+e.toString());
        //}
    }

    public static boolean compareLDAPInfo(Object obj, AuthInfo ldap) throws Exception{
        if (obj instanceof AuthInfo){
            AuthInfo objInfo = (AuthInfo)obj;
            if (!objInfo.getServerName().equals(ldap.getServerName())
                ||!objInfo.getDistinguishedName().equals(ldap.getDistinguishedName())
                ||!objInfo.getAuthenticateType().equals(ldap.getAuthenticateType())
                ||(!objInfo.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) && !objInfo.getAuthenticateID().equals(ldap.getAuthenticateID()))
                ||(!objInfo.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) && !objInfo.getAuthenticatePasswd().equals(ldap.getAuthenticatePasswd()))
                ||!objInfo.getTLS().equals(ldap.getTLS())
                ||!objInfo.getCAType().equals(ldap.getCAType())
                ||(!objInfo.getCAType().equals(AuthLDAPDomain.CATYPE_NOSPECIFY) && !objInfo.getCA().equals(ldap.getCA()))
            ){
                return false;
            }else{
                return true;
            }
        }else if (obj instanceof NativeInfo){
            NativeInfo objInfo = (NativeInfo)obj;
            if (!objInfo.getServerName().equals(ldap.getServerName())
                ||!objInfo.getDistinguishedName().equals(ldap.getDistinguishedName())
                ||!objInfo.getAuthenticateType().equals(ldap.getAuthenticateType())
                ||(!objInfo.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) && !objInfo.getAuthenticateID().equals(ldap.getAuthenticateID()))
                ||(!objInfo.getAuthenticateType().equals(AuthLDAPDomain.TYPE_ANON) && !objInfo.getAuthenticatePasswd().equals(ldap.getAuthenticatePasswd()))
                ||!objInfo.getTLS().equals(ldap.getTLS())
                ||!objInfo.getCAType().equals(ldap.getCAType())
                ||(!objInfo.getCAType().equals(AuthLDAPDomain.CATYPE_NOSPECIFY) && !objInfo.getCA().equals(ldap.getCA()))
            ){
                return false;
            }else{
                return true;
            }
        }else {
            return false;
        }
    }

    public static void setADSConf(String target, String ntdomain, 
        String dnsDomain, String kdcServer) throws Exception{
        MapdCommonSOAPClient.setADSConf(
            target, ntdomain, dnsDomain, kdcServer);
        String friend = Soap4Cluster.whoIsMyFriend(target);
        if(friend != null){
            MapdCommonSOAPClient.setADSConf(
                friend, ntdomain, dnsDomain, kdcServer);
        }
    }

    public static void checkoutADSFiles(String target, String ntdomain) 
        throws Exception{
        MapdCommonSOAPClient.checkoutADSFiles(target, ntdomain);
        String friend = Soap4Cluster.whoIsMyFriend(target);
        if(friend != null){
            try{
                MapdCommonSOAPClient.checkoutADSFiles(friend, ntdomain);
            }catch(Exception e){
                MapdCommonSOAPClient.rollbackADSFiles(target, ntdomain);
                throw e;
            }
        }
    }

    public static void checkinADSFiles(String target, String ntdomain)
        throws Exception{
        MapdCommonSOAPClient.checkinADSFiles(target, ntdomain);
        String friend = Soap4Cluster.whoIsMyFriend(target);
        if(friend != null){
            MapdCommonSOAPClient.checkinADSFiles(friend, ntdomain);
        }
    }

    public static void rollbackADSFiles(String target, String ntdomain)
        throws Exception{
        MapdCommonSOAPClient.rollbackADSFiles(target, ntdomain);
        String friend = Soap4Cluster.whoIsMyFriend(target);
        if(friend != null){
            MapdCommonSOAPClient.rollbackADSFiles(friend, ntdomain);
        }
    }
    
    public static boolean isUsedNISDomain(String target, String nisDomain)
        throws Exception{
        if (APISOAPClient.isUsedNISDomain(target,nisDomain)
            || MapdCommonSOAPClient.isUsedNISDomainByNFS(target,nisDomain)){
            return true;
        }
        String friend = Soap4Cluster.whoIsMyFriend(target);
        if(friend != null){
            return APISOAPClient.isUsedNISDomain(friend,nisDomain)
                || MapdCommonSOAPClient.isUsedNISDomainByNFS(friend,nisDomain);
        }
        return false;
    }

    public static Vector getADSConf(String target, String ntDomain)
        throws Exception{
        Vector vt = MapdCommonSOAPClient.getADSConf(target,ntDomain);
        if (vt == null || vt.get(1) == null 
            || ((String)vt.get(1)).equals("")){
            String friend = Soap4Cluster.whoIsMyFriend(target);
            if(friend != null){
                vt = MapdCommonSOAPClient.getADSConf(
                      friend, ntDomain);
            }                
        }
        return vt;
    }
    
    public static String getHasLdapSam (String i_target)throws Exception{
        //called at the pages: UserMapping(Data),UserMapping(Client),FTP
        return getHasLdapSam(i_target, "", "");
    }
    
    public static String getHasLdapSam (String i_target, String localdomain,
                                         String netbios)throws Exception{
        //called at CIFS page
        String hasLdapSam = MapdCommonSOAPClient.getHasLdapSam(i_target, localdomain, netbios);
        if(!hasLdapSam.equals("true")){
            String friend = Soap4Cluster.whoIsMyFriend(i_target);
            if(friend != null){
                hasLdapSam = MapdCommonSOAPClient.getHasLdapSam(friend, localdomain, netbios);
            }
        }
        return hasLdapSam;
    }
}
