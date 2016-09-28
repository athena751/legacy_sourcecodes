/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.base;

//import com.nec.sydney.system.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import java.util.*; 
import com.nec.sydney.atom.admin.base.api.*;

public class APISOAPClient implements NasConstants
{
    private static final String cvsid     = "@(#) $Id: APISOAPClient.java,v 1.8 2007/04/27 00:55:51 xingyh Exp $";
    private static final String URN_API_SERVICE        = "urn:APIConf";
    
    public static TreeMap getExportGroups(String routerUrl) throws Exception{
        TreeMap result = (TreeMap)getExportGroups(routerUrl,null);
        return result;
    }
    
    public static Vector getDirList(String hexpath , String type , String target) throws Exception {
        Vector paramVec = new Vector();
        paramVec.add(hexpath);
        paramVec.add(type);

        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec , "getDirList" , URN_API_SERVICE , target);
        return rtValue.getVector();
    }
    
    public static TreeMap getExportGroups(String routerUrl,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        SoapRpsVector rtValue = new SoapRpsVector();

        if (groupNo==null){
            rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc("getExportGroups",URN_API_SERVICE,routerUrl);
        }else{
            paramVec.add(groupNo);
            if (groupNo.equals("1")){
                rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec,"getExportGroups",URN_API_SERVICE,routerUrl,WHICH_NODE_ID1);
            }else if(groupNo.equals("0")){
                rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec,"getExportGroups",URN_API_SERVICE,routerUrl,WHICH_NODE_ID0);
            }
        }

        Vector tmpVec = rtValue.getVector();
        int size = tmpVec.size();
        TreeMap result = new TreeMap();
    	for( int i = 0 ; i < size ; i+=2){
    	    ExportRoot er = new ExportRoot();
    	    er.setPath((String)tmpVec.get(i));
    	    er.setCodePage((String)tmpVec.get(i+1));
    	    result.put((String)tmpVec.get(i),er);
    	}
        return result;
    }
       
    public static String getCodepage(String routerUrl,String exportgroup) throws Exception{
        return getCodepage(routerUrl,exportgroup,null);        
    }
    
    public static String getCodepage(String routerUrl,String exportgroup,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(exportgroup);
        SoapRpsString rtValue = null;
        if (groupNo==null){
            rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getCodepage",URN_API_SERVICE,routerUrl);
        }else{
            paramVec.add(groupNo);
            if (groupNo.equals("1")){
                rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getCodepage",URN_API_SERVICE,routerUrl,WHICH_NODE_ID1);    
            }else if (groupNo.equals("0")){
                rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getCodepage",URN_API_SERVICE,routerUrl,WHICH_NODE_ID0);
            }
        }
        return rtValue.getString();
    } 
     
    public static LinkedHashMap getMountpointLV(String routerUrl,String hexMountpoint) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(hexMountpoint);
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec,"getMountpointLV",URN_API_SERVICE,routerUrl);
        Vector tmpVec = rtValue.getVector();
        int size = tmpVec.size();
        LinkedHashMap result = new LinkedHashMap();
    	for( int i = 0 ; i < size ; i+=2){
    	    result.put((String)tmpVec.get(i+1),(String)tmpVec.get(i));
    	}
        return result;
    }
    
    public static Vector getALLExportRootInfo(String routerUrl) throws Exception{
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc("getAllExportRootInfo", URN_API_SERVICE, routerUrl);
        return rtValue.getVector();
    }

    public static LocalDomain getLocalDomainInfo(String routerUrl, String exportPath) throws Exception{
        LocalDomain rtValue = (LocalDomain)getLocalDomainInfo(routerUrl,exportPath,null);
        return rtValue;
    }

    public static LocalDomain getLocalDomainInfo(String routerUrl, String exportPath, String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(exportPath);
        
        LocalDomain rtValue = new LocalDomain();
        if (groupNo==null){
            rtValue = (LocalDomain)SoapClientBase.execSoapServerFunc(paramVec, "getLocalDomain", URN_API_SERVICE, routerUrl);
        }else{
            paramVec.add(groupNo);
            if (groupNo.equals("1")){
                rtValue = (LocalDomain)SoapClientBase.execSoapServerFunc(paramVec, "getLocalDomain", URN_API_SERVICE, routerUrl,WHICH_NODE_ID1);
            }else if(groupNo.equals("0")){
                rtValue = (LocalDomain)SoapClientBase.execSoapServerFunc(paramVec, "getLocalDomain", URN_API_SERVICE, routerUrl,WHICH_NODE_ID0);    
            }
        }
        return rtValue;
    }
    public static boolean checkNISDomain(String routerUrl, Domain nisDomain) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(nisDomain);
        SoapRpsBoolean rtValue = (SoapRpsBoolean)SoapClientBase.execSoapServerFunc(paramVec, "checkNisDomain", URN_API_SERVICE, routerUrl);
        return rtValue.getBoolean();
    }
    
    public static String getNisDomainServer(String nisDomain, String target) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(nisDomain);
        SoapRpsString trans = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec, "getNisDomainServer", URN_API_SERVICE, target);
        return trans.getString();
    }
    
    //Wrote by hetao start:
    public static boolean hasUnixStyleNative(String routerUrl) throws Exception{
        SoapRpsBoolean rtValue = (SoapRpsBoolean)SoapClientBase.execSoapServerFunc(
                                    "hasUnixStyleNative", 
                                    URN_API_SERVICE, 
                                    routerUrl);
        return rtValue.getBoolean();
    }
    public static Vector getNativeList(String routerUrl) throws Exception{
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(
                                    "getNativeList", 
                                    URN_API_SERVICE, 
                                    routerUrl);
        return rtValue.getVector();
    }
    public static boolean checkNativeDomain(String routerUrl,
                                            String networkOrNTdomain,
                                            String kind) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(networkOrNTdomain);
        paramVec.add(kind);
        SoapRpsBoolean rtValue = (SoapRpsBoolean)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "checkNativeDomain", 
                                    URN_API_SERVICE, 
                                    routerUrl);
        return rtValue.getBoolean();
    }
    public static NativeDomain getNativeDomain(String routerUrl,
                                               String networkOrNTdomain,
                                               String kind) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(networkOrNTdomain);
        paramVec.add(kind);
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "getNativeDomain", 
                                    URN_API_SERVICE, 
                                    routerUrl);
        Vector result = rtValue.getVector();
        if( result.size() == 0){
            return null;
        }else{
            return (NativeDomain)result.get(0);
        }
    }
    
    public static AuthDomain getAuthDomain(String target, 
                                            String hexDirectMP) throws Exception{
        AuthDomain rtValue =(AuthDomain)getAuthDomain(target,hexDirectMP,null);
        return rtValue;
    }
    
    public static AuthDomain getAuthDomain(String target, 
                                            String hexDirectMP,String groupNo) throws Exception{
        Vector paramVec          = new Vector();
        paramVec.add(hexDirectMP);
        
        SoapRpsVector rtValue = new SoapRpsVector();
        if (groupNo==null){
            rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "getAuthDomain", 
                                    URN_API_SERVICE, 
                                    target);
        }else{
            paramVec.add(groupNo);
            if (groupNo.equals("1")){
                rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "getAuthDomain", 
                                    URN_API_SERVICE, 
                                    target,
                                    WHICH_NODE_ID1);
            }else if(groupNo.equals("0")){
                rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "getAuthDomain", 
                                    URN_API_SERVICE, 
                                    target,
                                    WHICH_NODE_ID0);
            }
        }                                    
        Vector result = rtValue.getVector();
        if( result.size() == 0){
            return null;
        }else{
            return (AuthDomain)result.get(0);
        }
    }
    
    public static Map getAuthDomain(String target, Vector hexDirectMPs) throws Exception{
        HashMap result  = new HashMap();
        Vector paramVec = new Vector();
        paramVec.add(hexDirectMPs);
        SoapRpsHashtable rtValue = (SoapRpsHashtable)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "getAuthList", 
                                    URN_API_SERVICE, 
                                    target);
        Hashtable rpsRslt        = rtValue.getHash();
        Enumeration keys         = rpsRslt.keys();
        while( keys.hasMoreElements()){
            String key = (String)keys.nextElement();
            result.put(key,rpsRslt.get(key));
        }
        return result;
    }
    
    public static AuthDomain getAuthDomainByKind(String target, 
                                                String exportroot,
                                                String kind)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(exportroot);
        paramVec.add(kind);
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "getAuthDomainByKind", 
                                    URN_API_SERVICE, 
                                    target);
        Vector result = rtValue.getVector();
        if( result.size() == 0){
            return null;
        }else{
            return (AuthDomain)result.get(0);
        }
    }
    
    public static boolean checkExportAuthbyKind(String target ,
                                                 String exportroot,
                                                 String kind)throws Exception{
        AuthDomain aDomain = APISOAPClient.getAuthDomainByKind(target, exportroot,kind);
        if(aDomain == null){
            return false;
        }else{
            return true;
        }
    }  
    public static boolean isUsedNISDomain(String target, 
                                            String nisDomainName)throws Exception{                                          
        Vector paramVec = new Vector();
        paramVec.add(nisDomainName);
        SoapRpsBoolean rtValue = (SoapRpsBoolean)SoapClientBase.execSoapServerFunc(
                                    paramVec, 
                                    "isUsedNISDomain", 
                                    URN_API_SERVICE, 
                                    target);
        return rtValue.getBoolean();
    }
    //Wrote by hetao end;
   
    public static String makeAllDirectory(String groupNo,String target) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(groupNo);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(
                                        paramVec, 
                                        "makeAllDirectory", 
                                        URN_API_SERVICE, 
                                        target);
        return rtValue.getString();
    }
}//end of class
