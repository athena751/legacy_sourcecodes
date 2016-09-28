/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.quota.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.net.soap.*;

import java.util.*; 
import java.io.*;

public class QuotaSOAPClient implements NasConstants,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: QuotaSOAPClient.java,v 1.2302 2006/01/03 02:42:13 cuihw Exp $";
    private static final String URN_QUOTA_SERVICE = "urn:QuotaConf";

    public static void setQuota(String routerUrl, String filesystem , String idnumber , String blocksoft , String blockhard , String filesoft , String filehard , String flagUser, boolean isDirQuota)throws Exception
    {
        QuotaInfo quotaInfo = new QuotaInfo();
        quotaInfo.setID(idnumber);
        quotaInfo.setBlockSoftLimit(blocksoft);
        quotaInfo.setBlockHardLimit(blockhard);
        quotaInfo.setFileSoftLimit(filesoft);
        quotaInfo.setFileHardLimit(filehard);

        Vector paramVec = new Vector();    
        paramVec.add(filesystem);
        paramVec.add(quotaInfo);
        paramVec.add(flagUser);
        paramVec.add(new Boolean(isDirQuota));
        SoapClientBase.execSoapServerFunc(paramVec,"setQuota",URN_QUOTA_SERVICE,routerUrl);
    }

    public static void startQuota (String routerUrl , String filesystem, boolean isDirQuota) throws Exception
    {
        Vector paramVec = new Vector();    
        paramVec.add(filesystem);
        paramVec.add(new Boolean(isDirQuota));
        SoapClientBase.execSoapServerFunc(paramVec,"startQuota",
                                        URN_QUOTA_SERVICE,routerUrl);
    }

    public static void stopQuota (String routerUrl , String filesystem, boolean isDirQuota) throws Exception
    {
        Vector paramVec = new Vector();    
        paramVec.add(filesystem);
        paramVec.add(new Boolean(isDirQuota));
        SoapClientBase.execSoapServerFunc(paramVec,"stopQuota",
                                    URN_QUOTA_SERVICE,routerUrl);
    }

    public static void setGraceTime(String routerUrl, String userblock, String userfile, String groupblock, String groupfile, String dirblock, String dirfile, String filesystem, boolean isDirQuota) throws Exception
    {
        Vector paramVec = new Vector();    
        paramVec.add(userblock);
        paramVec.add(userfile);
        paramVec.add(groupblock);
        paramVec.add(groupfile);
        paramVec.add(dirblock);
        paramVec.add(dirfile);
        paramVec.add(filesystem);
        paramVec.add(new Boolean(isDirQuota));
        SoapClientBase.execSoapServerFunc(paramVec,"setGraceTime",URN_QUOTA_SERVICE,routerUrl);
    }
    
    public static String[] getOneReport(String routerUrl, String filesystem, String commandid, String ID) throws Exception
    {
           Vector paramVec = new Vector();    
           paramVec.add(filesystem);
           paramVec.add(commandid);
           paramVec.add(ID);
           SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getOneReport",URN_QUOTA_SERVICE,routerUrl);
           String limitInfo  = (String)rtValue.getString();
           if(limitInfo.trim().equals("")){
               return null;
           }else{
               return limitInfo.split("\\s+");
           }
    }

    public static Vector getReport(String routerUrl, String filesystem, String commandid, String type, String fsType, String limit, String displayControl, boolean isDirQuota) throws Exception
    {
        Vector paramVec = new Vector();    
        paramVec.add(filesystem);
        paramVec.add(commandid);
        paramVec.add(type);
        paramVec.add(fsType);
        paramVec.add(limit);
        paramVec.add(displayControl); //added by maojb on 2003.8.1
        paramVec.add(new Boolean(isDirQuota));
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec,"getReport",URN_QUOTA_SERVICE,routerUrl);
        Vector reports = (Vector)rtValue.getVector();
        return reports;
    }

    public static String getQuotaStatus(String routerUrl, String filesystem, boolean isDirQuota) throws Exception
    {
        Vector paramVec = new Vector();    
        paramVec.add(filesystem);
        paramVec.add(new Boolean(isDirQuota));
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getQuotaStatus",URN_QUOTA_SERVICE,routerUrl);
        return rtValue.getString();    
    }

    public static String getFsType(String routerUrl,String path) throws Exception
       {
        Vector paramVec = new Vector();    
        paramVec.add(path);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getFsType",URN_QUOTA_SERVICE,routerUrl);
        return rtValue.getString();    
    } //end of "getFsType()"

    public static String getIDFromName(String routerUrl,String name,String path,String flag) throws Exception
       {
        Vector paramVec = new Vector();    
        paramVec.add(name);
        paramVec.add(path);
        paramVec.add(flag);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"getIDFromName",URN_QUOTA_SERVICE,routerUrl);
        return rtValue.getString();
    } //end of "getIDFromName()"    

    public static Vector getGraceTime(String filesystem, boolean isDirQuota, String routerUrl) throws Exception
       {
        Vector paramVec = new Vector();    
        paramVec.add(filesystem);
        paramVec.add(new Boolean(isDirQuota));
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec,"getGraceTime",URN_QUOTA_SERVICE,routerUrl);
        return rtValue.getVector();
    } //end of "getGraceTime()"     
    
    public static Vector getDataMap(String routerUrl, String filesystem) throws Exception{
         Vector paramVec = new Vector();
         paramVec.add(filesystem);
         SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec,"getDataMap",URN_QUOTA_SERVICE, routerUrl); 
         return rtValue.getVector();
    }
    
}