/*
*      Copyright (c) 2001 NEC Corporation
*
*      NEC SOURCE CODE PROPRIETARY
*
*      Use, duplication and disclosure subject to a source code
*      license agreement with NEC Corporation.
*/

package com.nec.sydney.beans.nashead;

import com.nec.sydney.atom.admin.nashead.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import java.util.*;

public class NasHeadSOAPClient implements NasHeadConstants,NSExceptionMsg{
    private static final String     cvsid = "@(#) NasHeadSOAPClient.java,v 1.5 2004/03/15 08:46:08 caoyh Exp";
    private static final String     URN_NASHEAD_SERVICE = "urn:NasHeadConf";
    
    public static SoapRpsString getHBAInfo(String routerUrl, boolean isPort) throws Exception{
        Vector paramVec = new Vector(); 
        paramVec.add(new Boolean(isPort));
        SoapRpsString transStr = (SoapRpsString)SoapClientBase.
                               execSoapServerFunc(paramVec,"getHBAInfo",URN_NASHEAD_SERVICE,routerUrl);
        return transStr;       
    }
    
    public static String ldAutoLink(String url) throws Exception{
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc("ldAutoLink",URN_NASHEAD_SERVICE,url);
        return rtValue.getString();
    }
    
    public static String getStorageName(String wwnn, String url) throws Exception{
        Vector vPara = new Vector();
        vPara.add(wwnn);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(vPara,"getStorageName",URN_NASHEAD_SERVICE,url);
        return rtValue.getString();
    }
    
    public static void setStorageName(String wwnn, String storageName, String url)throws Exception{
        Vector vPara = new Vector();
        vPara.add(wwnn);
        vPara.add(storageName);
        SoapClientBase.execSoapServerFunc(vPara, "setStorageName",URN_NASHEAD_SERVICE,url);
    }
    
    public static Vector getStorageList (String url) throws Exception{
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc("getStorageList",URN_NASHEAD_SERVICE ,url);
        return rtValue.getVector();
    }
    
    public static Vector getLunList(String url, String wwnn, String needScan, boolean isNsview) throws Exception{
        Vector vPara = new Vector();
        vPara.add(wwnn);
        vPara.add(needScan);
		vPara.add(new Boolean(isNsview));
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(vPara, "getLunList",URN_NASHEAD_SERVICE ,url);
        return rtValue.getVector();
    }
    
    public static void deleteLUN(String devicepath, String url) throws Exception{
        Vector vPara = new Vector();
        vPara.add(devicepath);
        SoapClientBase.execSoapServerFunc(vPara, "deleteLUN",URN_NASHEAD_SERVICE ,url);
    }
    public static Vector getUnlinkedLunList(String url) throws Exception{
         SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc("getUnlinkedLunList",URN_NASHEAD_SERVICE ,url);
         return rtValue.getVector();
    }
    public static Vector setLunLink(String url, String info, String flag) throws Exception{
        Vector vPara = new Vector();
        vPara.add(info);
        vPara.add(flag);
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(vPara, "setLunLink",URN_NASHEAD_SERVICE ,url);
        return rtValue.getVector();
    }
}