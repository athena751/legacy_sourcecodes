/*
*      Copyright (c) 2001 NEC Corporation
*
*      NEC SOURCE CODE PROPRIETARY
*
*      Use, duplication and disclosure subject to a source code
*      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.http;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.http.*;
import com.nec.sydney.framework.tools.xml2html.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.net.soap.*;
import javax.servlet.http.HttpSession;
//import com.nec.sydney.system.*;
import java.util.*;
import java.io.*;

public class HTTPSOAPClient implements NasConstants,NSExceptionMsg{


    private static final String  cvsid = "@(#) $Id: HTTPSOAPClient.java,v 1.2301 2004/01/05 02:14:27 zhangjx Exp";
    private static final String  URN_HTTP_SERVICE = "urn:HTTPConf";

    public static HTTPInfo getHTTPInfo(HttpSession session,String node, String url, String infoLocation) throws Exception{
        Vector vPara = new Vector();
        vPara.add(node);
        vPara.add(infoLocation);
        HTTPInfo httpInfo = (HTTPInfo)SoapClientBase
                .execSoapServerFunc(vPara, "getHTTPInfo", URN_HTTP_SERVICE, url);
        if (httpInfo.isSuccessful()){
            HTTPBasicInfo basicInfo = httpInfo.getBasicInfo();
            String selectableFunctions = basicInfo.getSelectableFunctions();
            String defaultOptions = basicInfo.getDefaultOptions();
            basicInfo.setSelectableFunctions(HTMLMaker.makeHTML(new ByteArrayInputStream(selectableFunctions.getBytes()),session));
            basicInfo.setDefaultOptions(HTMLMaker.makeHTML(new ByteArrayInputStream(defaultOptions.getBytes()),session));
            httpInfo.setBasicInfo(basicInfo);
            HTTPServerInfo serverInfo = httpInfo.getMainServer();
            Map directories = serverInfo.getDirectoryMap();
            Iterator itr = directories.keySet().iterator();
            while(itr.hasNext()){
                convertDynamic(session,((HTTPDirectoryInfo)directories.get(itr.next())));
            }
        }
        return httpInfo;

    }

    public static HTTPInfo getHTTPInfo(HttpSession session,String node, String url, String infoLocation, String isNsview) throws Exception{
        Vector vPara = new Vector();
        vPara.add(node);
        vPara.add(infoLocation);
        vPara.add(isNsview);
        HTTPInfo httpInfo = (HTTPInfo)SoapClientBase
                .execSoapServerFunc(vPara, "getHTTPInfo", URN_HTTP_SERVICE, url);
        if (httpInfo.isSuccessful()){
            HTTPBasicInfo basicInfo = httpInfo.getBasicInfo();
            String selectableFunctions = basicInfo.getSelectableFunctions();
            String defaultOptions = basicInfo.getDefaultOptions();
            basicInfo.setSelectableFunctions(HTMLMaker.makeHTML(new ByteArrayInputStream(selectableFunctions.getBytes()),session));
            basicInfo.setDefaultOptions(HTMLMaker.makeHTML(new ByteArrayInputStream(defaultOptions.getBytes()),session));
            httpInfo.setBasicInfo(basicInfo);
            HTTPServerInfo serverInfo = httpInfo.getMainServer();
            Map directories = serverInfo.getDirectoryMap();
            Iterator itr = directories.keySet().iterator();
            while(itr.hasNext()){
                convertDynamic(session,((HTTPDirectoryInfo)directories.get(itr.next())));
            }
        }
        return httpInfo;

    }
    
    public static HTTPBasicInfo getBasicInfo(HttpSession session,String node, String url) throws Exception{
        Vector vPara = new Vector();
        vPara.add(node);
        HTTPBasicInfo basicInfo = (HTTPBasicInfo)SoapClientBase
                .execSoapServerFunc(vPara, "getBasicInfo", URN_HTTP_SERVICE, url);
        if (basicInfo.isSuccessful()){
            String selectableFunctions = basicInfo.getSelectableFunctions();
            String defaultOptions = basicInfo.getDefaultOptions();
            basicInfo.setSelectableFunctions(HTMLMaker.makeHTML(new ByteArrayInputStream(selectableFunctions.getBytes()),session));
            basicInfo.setDefaultOptions(HTMLMaker.makeHTML(new ByteArrayInputStream(defaultOptions.getBytes()),session));
            //throw new Exception("dynamic:  "+selectableFunctions+"##"+basicInfo.getSelectableFunctions());
        }
        return basicInfo;
    }

    public static HTTPServerInfo getServerInfo(String node, String serverType,
            String virtualNickName,
            String url)
            throws Exception{
        Vector vPara = new Vector();
        vPara.add(node);
        vPara.add(serverType);
        vPara.add(virtualNickName);
        return (HTTPServerInfo)SoapClientBase
                .execSoapServerFunc(vPara,
                "getServerInfo",
                URN_HTTP_SERVICE, url);
    }



    public static HTTPDirectoryInfo getDirectoryInfo(HttpSession session,
            String node, String server,
            String dir,
            String url)
            throws Exception{
        Vector vPara = new Vector();
        vPara.add(node);
        vPara.add(server);
        vPara.add(dir);
        HTTPDirectoryInfo directoryInfo = (HTTPDirectoryInfo)SoapClientBase
                     .execSoapServerFunc(vPara, "getDirectoryInfo", URN_HTTP_SERVICE, url);
        if (directoryInfo.isSuccessful()){
            convertDynamic(session,directoryInfo);
        }
        return directoryInfo;
    }

    private static void convertDynamic(HttpSession session,HTTPDirectoryInfo directoryInfo) throws Exception{
            String directoryOptions = directoryInfo.getDirectoryOptions();
            String allowOptions = directoryInfo.getAllowOverwriteOptions();
            directoryInfo.setDirectoryOptions(HTMLMaker.makeHTML(new ByteArrayInputStream(directoryOptions.getBytes()),session));
            directoryInfo.setAllowOverwriteOptions(HTMLMaker.makeHTML(new ByteArrayInputStream(allowOptions.getBytes()),session));
    }

    public static SoapResponse setBasicInfo(String node,
            HTTPBasicInfo basicInfo,
            String url)
            throws Exception{
        Vector vPara = new Vector();
        vPara.add(node);
        vPara.add(basicInfo);
        return (SoapResponse)SoapClientBase
                .execSoapServerFunc(vPara,
                "setBasicInfo",
                URN_HTTP_SERVICE, url, false);
    }

    public static SoapResponse setServerInfo(String node, String serverType,
            String nickName,
            HTTPServerInfo serverInfo,
            String url)
               throws Exception{
           Vector vPara = new Vector();
           vPara.add(node);
           vPara.add(serverType);
           vPara.add(nickName);
           vPara.add(serverInfo);
           return (SoapResponse)SoapClientBase
                   .execSoapServerFunc(vPara,
                   "setServerInfo",
                   URN_HTTP_SERVICE, url, false);
    }

    public static SoapResponse setAllInfo(String node,
            String url)throws Exception{
        Vector vPara = new Vector();
        vPara.add(node);
        return (SoapResponse)SoapClientBase
                .execSoapServerFunc(vPara,
                "doConfig",
                URN_HTTP_SERVICE, url, false);
    }

    public static Vector getDir(String routerUrl, String path, String flag)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(path);
        paramVec.add(flag);
        SoapRpsVector rtValue = (SoapRpsVector)SoapClientBase.execSoapServerFunc(paramVec,"getDir",URN_HTTP_SERVICE,routerUrl);
        return rtValue.getVector();
    }

    public static SoapResponse setDirectoryInfo(String routerUrl,
                                      String node,
                                      String serverType,
                                      Vector mDir,
                                      String nickName
                                      )throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(node);
        paramVec.add(serverType);
        paramVec.add(mDir);
        paramVec.add(nickName);
        SoapResponse rtValue = (SoapResponse)SoapClientBase.execSoapServerFunc(paramVec,"setDirectoryInfo",URN_HTTP_SERVICE,routerUrl);
        return rtValue;
    }
}
