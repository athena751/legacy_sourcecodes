/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

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
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.atom.admin.nfs.NativeInfo; 


import java.util.*; 
import java.io.*;

public class MAPDSOAPClient implements NasConstants,NSExceptionMsg{


    private static final String     cvsid = "@(#) $Id: MAPDSOAPClient.java,v 1.2303 2004/11/12 02:34:49 caoyh Exp $";
    private static final String     URN_MAPD_SERVICE             = "urn:MAPDConf";


//2.4.3.1

    public static String setAuthLDAP(String routerUrl,
                                     AuthInfo auth) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(auth);
        
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.
            execSoapServerFunc(paramVec,"setAuthLDAP",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();                
    }

    public static String setAuthNIS(String routerUrl,AuthInfo auth) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(auth);
        
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"setAuthNIS",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();                
    }

 //2.4.3.2
    public static String setAuthPWD(String routerUrl,AuthInfo auth) throws Exception
    {

        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"setAuthPWD",URN_MAPD_SERVICE,routerUrl);
        
        return (String)rtValue.getString();    

    }

//2.4.3.3
    public static String setAuthSHR(String routerUrl,AuthInfo auth) throws Exception
    {

        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"setAuthSHR",URN_MAPD_SERVICE,routerUrl);
        
        return (String)rtValue.getString();    

    }
//2.4.3.4
    public static String setAuthDMC(String routerUrl,AuthInfo auth) throws Exception
    {

        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"setAuthDMC",URN_MAPD_SERVICE,routerUrl);
        
        return (String)rtValue.getString();    

    }
//2.4.3.7
    public static String setAuthDMCAgain(String routerUrl,AuthInfo auth) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"setAuthDMCAgain",URN_MAPD_SERVICE,routerUrl);
        
        return (String)rtValue.getString();    
    }
    //2.4.3.8

    public static void setAuthNISAgain(String routerUrl,AuthInfo auth) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapClientBase.execSoapServerFunc(paramVec,"setAuthNISAgain",URN_MAPD_SERVICE,routerUrl);        
    }
//2.4.3.5
    public static String  getAuthRegion(String routerUrl,String path) throws Exception
    {    
        Vector paramVec = new Vector();
        paramVec.add(path);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getAuthRegion",URN_MAPD_SERVICE,routerUrl);
        
        return (String)rtValue.getString();    
     }   
//2.4.3.6
    public static String  getFsType(String routerUrl,String path) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(path);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getFsType",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();    
     } 
 
    //public static String setAuthLocalDomain(String routerUrl,String export,String localdomain,String netbios) throws Exception
    public static String setAuthLocalDomain(String routerUrl,String export,String globaldomain,String localdomain) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(export);
        paramVec.add(globaldomain);
        paramVec.add(localdomain);
        //paramVec.add(netbios);                
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"addLocalDomain",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();    
    }        

    public static void setMapdDelete(String routerUrl, String region) throws Exception 
    {
        Vector paramVec = new Vector();
        paramVec.add(region);
        SoapClientBase.execSoapServerFunc(paramVec,"setMapdDelete",URN_MAPD_SERVICE,routerUrl);
    }

    //public static String setSHRMapdDomain(String routerUrl,String export,String localdomain,String netbios,String uname,String uid, String gname, String gid) throws Exception
    public static String setSHRMapdDomain(String routerUrl,String export,String uname,String uid, String gname, String gid) throws Exception
    {    
        Vector paramVec = new Vector();
        paramVec.add(export);
        paramVec.add(uname);
        paramVec.add(uid);
        paramVec.add(gname);
        paramVec.add(gid);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"setSHRMapdDomain",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();    
    }
        
    public static void delNative(String routerUrl,String type,String domain) throws Exception{
        delNative(routerUrl, type, domain, "");
    }
    public static void delNative(String routerUrl,String type,String domain, String region) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(type);
        paramVec.add(domain);
        paramVec.add(region);
        SoapClientBase.execSoapServerFunc(paramVec,"delNative",URN_MAPD_SERVICE,routerUrl);
    }
    
    public static String addNative(String routerUrl, NativeInfo aNative,String writeLudbInfo)throws Exception 
    {
        Vector paramVec = new Vector();
        paramVec.add(aNative);        
        paramVec.add(writeLudbInfo);        
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"addNative",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();
    }
    
    public static String  getFsTypeFromFstab(String routerUrl,String path) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(path);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getFsTypeFromFstab",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();    
     } 

    public static void remoteSyncYPConf (String domain,String server,String oldserver,String routerUrl) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(domain);
        paramVec.add(server);
        paramVec.add(oldserver);        
        SoapClientBase.execSoapServerFunc(paramVec,"remoteSyncYPConf",URN_MAPD_SERVICE,routerUrl);            
    }
    
    public static String getLudbRoot(String routerUrl) throws Exception
    {
        Vector paramVec = new Vector();

        SoapRpsString rtValue = 
            (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getLUDBRoot",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();                
    }

    public static void removeLUDB(String routerUrl, AuthInfo auth) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(auth);

        SoapClientBase.execSoapServerFunc(paramVec,"removeLUDB",URN_MAPD_SERVICE,routerUrl);
        
    }

    public static void removeSHRFile(String routerUrl, AuthInfo auth) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(auth);

        SoapClientBase.execSoapServerFunc(paramVec,"removeSHRFile",URN_MAPD_SERVICE,routerUrl);        
    }

    public static void copyLUDB(String routerUrl, AuthInfo auth,String writeLudbInfo) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(auth);
        paramVec.add(writeLudbInfo);

        SoapClientBase.execSoapServerFunc(paramVec,"copyLUDB",URN_MAPD_SERVICE,routerUrl);
        
    }

    public static String setAuthPWD4CIFS(String routerUrl, AuthInfo auth) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapRpsString rtValue = 
            (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"setAuthPWD4CIFS",URN_MAPD_SERVICE,routerUrl);
        return (String)rtValue.getString();                
    }

    public static void rmsmbpasswd(String network,String netbios,
                               String ludb,String routerUrl) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(network);
        paramVec.add(netbios);
        paramVec.add(ludb);

        SoapClientBase.execSoapServerFunc(paramVec,"rmsmbpasswd",URN_MAPD_SERVICE,routerUrl);
    }

    public static void writeSMB4ADS(
        String target, AuthInfo auth)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapClientBase.execSoapServerFunc(
            paramVec,"writeSMB4ADS",URN_MAPD_SERVICE,target);
    }

    public static void setAuthADS(
        String target, AuthInfo auth)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(auth);
        SoapClientBase.execSoapServerFunc(
            paramVec,"setAuthADS",URN_MAPD_SERVICE,target);
    }

    public static void setAuthADSDomain(
        String target, String export,String ntDomain)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(export);
        paramVec.add(ntDomain);
        SoapClientBase.execSoapServerFunc(
            paramVec,"setAuthADSDomain",URN_MAPD_SERVICE,target);
    }
    
    public static void writeYPConf(String i_domain, String i_server, String oldServer, String target) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(i_domain);
        paramVec.add(i_server);
        paramVec.add(oldServer);
        SoapClientBase.execSoapServerFunc(paramVec, "writeYPConf", URN_MAPD_SERVICE, target);
    }   
}///end of SOAPClient 
