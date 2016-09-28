/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: FTPSOAPClient.java,v 1.2302 2008/12/23 04:57:35 gaozf Exp $";
 */
 package com.nec.sydney.beans.ftp;
 
 import com.nec.sydney.atom.admin.ftp.*;
 import com.nec.sydney.atom.admin.base.*;
 import com.nec.sydney.beans.base.*;

 import java.util.*;
 
public class FTPSOAPClient implements FTPConstants,NasConstants{

    private static final String     URN_FTP_SERVICE = "urn:FTPConf";
    
    public static void setMyNode(String url, FTPInfo info, FTPAuthInfo authinfo,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(info);
        paramVec.add(authinfo);        
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "setMyNode",
                                         URN_FTP_SERVICE, url);   
        
    }    
    public static void setFriendNode(String url, FTPInfo info, FTPAuthInfo authinfo,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(info);
        paramVec.add(authinfo);        
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "setFriendNode",
                                         URN_FTP_SERVICE, url);   
        
    }    
   // gaozf 20081203 start
    public static void setBothNode(String url, FTPInfo info, FTPAuthInfo authinfo,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(info);
        paramVec.add(authinfo);        
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "setBothNode",
                                         URN_FTP_SERVICE, url);   
    
    } 
    //end
    public static FTPInfo	getBaseInfo(String url,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(groupNo);
        SoapRpsFTPInfo rtValue = (SoapRpsFTPInfo)SoapClientBase.execSoapServerFunc(paramVec, "getBaseInfo",
                                                                URN_FTP_SERVICE,   url);   
        return rtValue.getFTPInfo();
    }
    //gaozf 20081204
    public static FTPInfo getFriendUseFTPServices(String url,String groupNo)throws Exception{
    	Vector paramVec = new Vector();
        paramVec.add(groupNo);
        SoapRpsFTPInfo rtValue = (SoapRpsFTPInfo)SoapClientBase.execSoapServerFunc(paramVec, "getFriendUseFTPServices",
                                                                URN_FTP_SERVICE,   url);   
        return rtValue.getFTPInfo();
    }
    //end  
    public static FTPAuthInfo	getAuthInfo(String url,String groupNo) throws Exception{
        return getAuthInfo(url,groupNo,null);
    }
    
    public static FTPAuthInfo	getAuthInfo(String url,String groupNo,String groupNoTakeOver) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(groupNo);
        SoapRpsFTPAuthInfo rtValue = null;
        if (groupNoTakeOver==null){
            rtValue = (SoapRpsFTPAuthInfo)SoapClientBase.execSoapServerFunc(paramVec, "getAuthInfo",
                                                                URN_FTP_SERVICE,   url);   
        }else{
            if (groupNoTakeOver.equals("0")){
                rtValue = (SoapRpsFTPAuthInfo)SoapClientBase.execSoapServerFunc(paramVec, "getAuthInfo",
                                                                URN_FTP_SERVICE,   url, WHICH_NODE_ID0);   
            }else if (groupNoTakeOver.equals("1")){
                rtValue = (SoapRpsFTPAuthInfo)SoapClientBase.execSoapServerFunc(paramVec, "getAuthInfo",
                                                                URN_FTP_SERVICE,   url, WHICH_NODE_ID1);   
            }
        }                                                         
        return rtValue.getInfo();
    }
/*    
    public static void      closeOriginPassive(String url, String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "closeOriginPassive",
                                         URN_FTP_SERVICE, url);   
    
    }
    public static void writeBaseConf(String url, FTPInfo info,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(info);
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "writeBaseConf",
                                         URN_FTP_SERVICE, url);   
        
    }
    
    public static void setAuthInfo(String url, FTPAuthInfo info,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(info);
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "setAuthInfo",
                                         URN_FTP_SERVICE, url);   
        
    }
    public static void writeUserAndAuth(String url,FTPInfo info,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(info);
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "writeUserAndAuth",
                                         URN_FTP_SERVICE, url);       
    
    }
    public static void setManageLan(String url,FTPInfo info) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(info);

        SoapClientBase.execSoapServerFunc(paramVec, "setManageLan",
                                         URN_FTP_SERVICE, url);       
    }
    public static void initFTPConf(String url,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "initFTPConf",
                                         URN_FTP_SERVICE, url);       
    }
    public static void  execFTPmkcnf(String url,String groupNo) throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "execFTPmkcnf",
                                         URN_FTP_SERVICE, url);       
    
    }   
    public static void  setServiceStatus(String url,FTPInfo info) throws Exception{ 
        Vector paramVec = new Vector();
        paramVec.add(info);
        SoapClientBase.execSoapServerFunc(paramVec, "setServiceStatus",
                                         URN_FTP_SERVICE, url);       
    }
    public static void  setPassivePorts(String url,FTPInfo info,String groupNo) throws Exception{
       Vector paramVec = new Vector();
        paramVec.add(info);
        paramVec.add(groupNo);
        SoapClientBase.execSoapServerFunc(paramVec, "setPassivePorts",
                                         URN_FTP_SERVICE, url);           
    }    
  */  
    public static String    getFTPServiceStatus(String url) throws Exception{
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc("getFTPServiceStatus", URN_FTP_SERVICE,url);
        return rtValue.getString();
    }

}
