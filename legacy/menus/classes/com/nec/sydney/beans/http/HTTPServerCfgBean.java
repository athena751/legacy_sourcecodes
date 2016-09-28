/*
*      Copyright (c) 2001 NEC Corporation
*
*      NEC SOURCE CODE PROPRIETARY
*
*      Use, duplication and disclosure subject to a source code
*      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.http;

import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import com.nec.sydney.atom.admin.http.HTTPConstants;
import com.nec.sydney.atom.admin.http.HTTPServerInfo;
import com.nec.sydney.beans.base.TemplateBean;
import com.nec.sydney.framework.NSException;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.sydney.net.soap.Soap4Cluster;
import com.nec.sydney.net.soap.SoapResponse;



public class HTTPServerCfgBean extends TemplateBean{
    private static final String     cvsid = "@(#) $Id: HTTPServerCfgBean.java,v 1.2302 2005/09/27 08:43:58 xingh Exp $";
    private HTTPServerInfo serverInfo;
    private String oldVirtualHostName = "";
    private String oldNickName = "";
    private static final String REDIRECT_URL = "../nas/http/httpinfo.jsp?infoLocation=tmp";

    public HTTPServerCfgBean(){
        serverInfo = new HTTPServerInfo();
    }

    public void onDisplay() {
    }

    public void onMainServerEdit()throws Exception{
        serverInfo = HTTPSOAPClient.getServerInfo(getMyNum(), "mainServer",
                "", target);
        session.setAttribute(HTTPConstants.SESSION_DIRECTORIES, new TreeMap());
    }

    public void onMainServerSet()throws Exception{
        SoapResponse sr;
        //ServerName must have value.
        /*
        if (serverInfo.getServerName() == null || serverInfo.getServerName().equals("")){
            SystemInfoSOAPClient soapclient = new SystemInfoSOAPClient();
            soapclient.setTarget(target);
            SystemInfo info0 = soapclient.getSystemInfo(-1);
            String node0 = info0.getUname().get(Uname.NODENAME);
            serverInfo.setServerName(node0);
        }
        */
        Map directory = (Map) session.getAttribute(HTTPConstants.SESSION_DIRECTORIES);
        serverInfo.setDirectoryMap(directory);
        setRedirectUrl(REDIRECT_URL);
        sr  = HTTPSOAPClient.setServerInfo(getMyNum(), "mainServer",
                "", serverInfo, target);
        if (sr.isSuccessful()) {
            String fnode = Soap4Cluster.whoIsMyFriend(target);
            if (fnode != null) {
                sr  = HTTPSOAPClient.setServerInfo(getMyNum(), "mainServer",
                        "", serverInfo, fnode);
            }
        }

        if (!sr.isSuccessful()) {
            int errorcode = sr.getErrorCode();
            if (errorcode == HTTPConstants.ERRORCODE_DIRECTORY_EXIST) {
                super.setMsg(NSMessageDriver.getInstance()
                        .getMessage(session,"common/alert/failed") + "\\r\\n"
                        + NSMessageDriver.getInstance()
                        .getMessage(session,"nas_http/alert/get_directory_exist"));
            } else {
                throw new NSException(sr.getErrorMessage());
            }
        }
    }

    public void onVirtualHostSet()throws Exception{
        SoapResponse sr;
        int errorcode = 0;

        TreeMap directory = (TreeMap) session.getAttribute(HTTPConstants.SESSION_DIRECTORIES);
        serverInfo.setDirectoryMap(directory);
        setRedirectUrl(REDIRECT_URL);
        oldNickName = oldNickName.equals("#")?"":oldNickName;
        sr  = HTTPSOAPClient.setServerInfo(getMyNum(), "virtualHost",
                oldNickName, serverInfo, target);
        if (sr.isSuccessful()) {
            String fnode = Soap4Cluster.whoIsMyFriend(target);
            if (fnode != null) {
                sr  = HTTPSOAPClient.setServerInfo(getMyNum(), "virtualHost",
                        oldNickName, serverInfo, fnode);
            }
        }

        if (!sr.isSuccessful()) {
            errorcode = sr.getErrorCode();
            if (errorcode == HTTPConstants.ERRORCODE_VIRTUALHOST_EXIST) {
                super.setMsg(NSMessageDriver.getInstance()
                        .getMessage(session,"common/alert/failed") + "\\r\\n"
                        + NSMessageDriver.getInstance()
                        .getMessage(session,"nas_http/alert/set_virtualhost_exist"));
            } else if (errorcode == HTTPConstants.ERRORCODE_DIRECTORY_EXIST) {
                super.setMsg(NSMessageDriver.getInstance()
                        .getMessage(session,"common/alert/failed") + "\\r\\n"
                        + NSMessageDriver.getInstance()
                        .getMessage(session,"nas_http/alert/get_directory_exist"));
            } else {
                throw new NSException(sr.getErrorMessage());
            }
        }
    }

    public void onVirtualHostEdit()throws Exception{
        serverInfo = HTTPSOAPClient.getServerInfo(getMyNum(), "virtualHost",
                serverInfo.getNickName(), target);
        session.setAttribute(HTTPConstants.SESSION_DIRECTORIES, new TreeMap());
    }

    public void onVirtualHostAdd()throws Exception{
        serverInfo = new HTTPServerInfo();
        serverInfo.setNickName("#");
        //get using port
        HTTPServerInfo tempServerInfo = HTTPSOAPClient.getServerInfo(getMyNum(), "virtualHost",
                                        serverInfo.getNickName(), target);
        serverInfo.setUsedPort(tempServerInfo.getUsedPort());
        //end of get using port

        session.setAttribute(HTTPConstants.SESSION_DIRECTORIES, new TreeMap());
        /*This is for the place where the directory write*/
        HTTPSOAPClient.setServerInfo(getMyNum(), "virtualHost",
                "#", serverInfo, target);
    }

    public void onVirtualHostDelete()throws Exception{
        SoapResponse sr;

        setRedirectUrl(REDIRECT_URL);
        serverInfo = new HTTPServerInfo();
        sr  = HTTPSOAPClient.setServerInfo(getMyNum(), "virtualHost",
                oldNickName, serverInfo, target);
        if (sr.isSuccessful()) {
            String fnode = Soap4Cluster.whoIsMyFriend(target);
            if (fnode != null) {
                sr  = HTTPSOAPClient.setServerInfo(getMyNum(), "virtualHost",
                        oldNickName, serverInfo, fnode);
            }
        }
        if (sr.isSuccessful()) {

        } else {
            throw new NSException(sr.getErrorMessage());
        }
    }

    public HTTPServerInfo getServerInfo() throws Exception {
        return serverInfo;
    }

    public void setVirtualHostName(String virtualHostName) {
        serverInfo.setVirtualHostName(virtualHostName);
    }

    public void setVirtualHostType(String virtualHostType) {
        serverInfo.setVirtualHostType(virtualHostType);
    }

    public void setServerName(String serverName) {
        serverInfo.setServerName(serverName);
    }

    public void setUsedIPAddrsMode(String usedIPAddrsMode) {
        serverInfo.setUsedIPAddrsMode(usedIPAddrsMode);
    }

    public void setUsedIPAddrs(String usedIPAddrs) {
        serverInfo.setUsedIPAddrs(usedIPAddrs);
    }

    public void setDocumentRoot(String documentRoot) {
        serverInfo.setDocumentRoot(documentRoot);
    }

    public void setServerAdmin(String serverAdmin) {
        serverInfo.setServerAdmin(serverAdmin);
    }

    public void setUnixUserName(String unixUserName) {
        serverInfo.setUnixUserName(unixUserName);
    }
    public void setUnixUserID(String unixUserID) {
        serverInfo.setUnixUserID(unixUserID);
    }
    public void setUnixGroupName(String unixGroupName) {
        serverInfo.setUnixGroupName(unixGroupName);
    }
    public void setUnixGroupID(String unixGroupID) {
        serverInfo.setUnixGroupID(unixGroupID);
    }
    public void setWindowsUserName(String windowsUserName) {
        serverInfo.setWindowsUserName(windowsUserName);
    }
    public void setWindowsGroupName(String windowsGroupName) {
        serverInfo.setWindowsGroupName(windowsGroupName);
    }
    public void setTransferLogMode(String transferLogMode) {
        serverInfo.setTransferLogMode(transferLogMode);
    }
    public void setTransferLogLocation(String transferLogLocation) {
        serverInfo.setTransferLogLocation(transferLogLocation);
    }
    public void setCustomLogAllowed(boolean customLogAllowed) {
        serverInfo.setCustomLogAllowed(customLogAllowed);
    }
    public void setCustomLogFileName(String customLogFileName) {
        serverInfo.setCustomLogFileName(customLogFileName);
    }
    public void setCustomLogFormat(String customLogFormat) {
        serverInfo.setCustomLogFormat(customLogFormat);
    }
    public void setErrorLogMode(String errorLogMode) {
        serverInfo.setErrorLogMode(errorLogMode);
    }
    public void setErrorLogLocation(String errorLogLocation) {
        serverInfo.setErrorLogLocation(errorLogLocation);
    }
    public void setErrorLogLevel(String errorLogLevel) {
        serverInfo.setErrorLogLevel(errorLogLevel);
    }
    public void setAccessFileName(String accessFileName) {
        serverInfo.setAccessFileName(accessFileName);
    }
    public void setUserDirAllowed(boolean userDirAllowed) {
        serverInfo.setUserDirAllowed(userDirAllowed);
    }
    public void setUserDirPattern(String userDirPattern) {
        serverInfo.setUserDirPattern(userDirPattern);
    }
    public void setUserDirMode(String userDirMode) {
        serverInfo.setUserDirMode(userDirMode);
    }
    public void setUserDirUserList(String userDirUserList) {
        serverInfo.setUserDirUserList(userDirUserList);
    }
    public void setNickName(String nickName) {
        serverInfo.setNickName(nickName);
    }
    public String getNickName() {
        return serverInfo.getNickName();
    }
    public void setOldNickName(String oldNickName) {
        this.oldNickName = oldNickName;
    }
    public Iterator getDirectoryIterator() {
        return serverInfo.getDirectoryMap().keySet().iterator();
    }
    public String getMyNumber() {
        return getMyNum();
    }
    private String infoLocation;
    public void setInfoLocation(String infoLocation){
        this.infoLocation = infoLocation;
    }
    public String getInfoLocation(){
        return this.infoLocation;
    }
}//end class