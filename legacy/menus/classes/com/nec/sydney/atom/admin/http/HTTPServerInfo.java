/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.http;
import java.util.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.atom.admin.http.*;
public class HTTPServerInfo extends SoapResponse implements HTTPConstants{
	private static final String	cvsid = "@(#) $Id: HTTPServerInfo.java,v 1.2300 2003/11/24 00:54:41 nsadmin Exp";

    private String virtualHostName = "";
    private String nickName = "";
    private String virtualHostType = VIRTUALHOSTMOD_IP_BASED;
    private String usedIPAddrs = ""; 
    private String usedIPAddrsMode = USEDIPADDSMODE_ALL;
    private String documentRoot = "";
    private String serverName = "";
    private String serverAdmin = "";
    private String unixUserName = USER_DEFAULT_NAME;
    private String unixUserID = "";
    private String unixGroupName = USER_DEFAULT_NAME;
    private String unixGroupID = "";
    private String windowsUserName = USER_DEFAULT_NAME;
    private String windowsGroupName = USER_DEFAULT_NAME;
    private String transferLogMode = TRANSFERLOGMODE_STANDARD;
    private String transferLogLocation = "";
    private boolean customLogAllowed = false;
    private String customLogFileName = "";
    private String customLogFormat = "";
    private String errorLogMode = ERRORLOGMODE_STANDARD;
    private String errorLogLocation = "";
    private String errorLogLevel = ERRORLOG_DEFAULT_LEVEL;
    private String accessFileName = ".htaccess";
    private boolean userDirAllowed = false;
    private String userDirPattern = "";
    private String userDirMode = DIR_ENABLE;
    private String userDirUserList = "" ;
    private Map directoryMap = new Hashtable();
	private String usedPort = "";

    public String getVirtualHostName(){
        return virtualHostName;
    }
    public void setVirtualHostName(String virtualHostName){
        this.virtualHostName = virtualHostName;
    }
    public String getNickName() {
        return nickName;
    }
    public void setNickName(String nickName) {
        this.nickName = nickName;
    }
    public String getVirtualHostType(){
        return virtualHostType;
    }
    public void setVirtualHostType(String virtualHostType){
        this.virtualHostType = virtualHostType;
    }
    public String getUsedIPAddrs(){
        return usedIPAddrs;
    }
    public void setUsedIPAddrs(String usedIPAddrs){
        this.usedIPAddrs = usedIPAddrs;
    }
    public String getUsedIPAddrsMode(){
        return usedIPAddrsMode;
    }
    public void setUsedIPAddrsMode(String usedIPAddrsMode){
        this.usedIPAddrsMode = usedIPAddrsMode;
    }
    public String getDocumentRoot(){
        return documentRoot;
    }
    public void setDocumentRoot(String documentRoot){
        this.documentRoot = documentRoot;
    }
    public String getServerName(){
        return serverName;
    }
    public void setServerName(String serverName){
        this.serverName = serverName;
    }
    public String getServerAdmin(){
        return serverAdmin;
    }
    public void setServerAdmin(String serverAdmin){
        this.serverAdmin = serverAdmin;
    }
    public String getUnixUserName(){
        return unixUserName;
    }
    public void setUnixUserName(String unixUserName){
        this.unixUserName = unixUserName;
    }
    public String getUnixUserID(){
        return unixUserID;
    }
    public void setUnixUserID(String unixUserID){
        this.unixUserID = unixUserID;
    }
    public String getUnixGroupName(){
        return unixGroupName;
    }
    public void setUnixGroupName(String unixGroupName){
        this.unixGroupName = unixGroupName;
    }
    public String getUnixGroupID(){
        return unixGroupID;
    }
    public void setUnixGroupID(String unixGroupID){
        this.unixGroupID = unixGroupID;
    }
    public String getWindowsUserName(){
        return windowsUserName;
    }
    public void setWindowsUserName(String windowsUserName){
        this.windowsUserName = windowsUserName;
    }
    public String getWindowsGroupName(){
        return windowsGroupName;
    }
    public void setWindowsGroupName(String windowsGroupName){
        this.windowsGroupName = windowsGroupName;
    }
    public String getTransferLogMode(){
        return transferLogMode;
    }
    public void setTransferLogMode(String transferLogMode){
        this.transferLogMode = transferLogMode;
    }
    public String getTransferLogLocation(){
        return transferLogLocation;
    }
    public void setTransferLogLocation(String transferLogLocation){
        this.transferLogLocation = transferLogLocation;
    }
    public boolean getCustomLogAllowed(){
        return customLogAllowed;
    }
    public void setCustomLogAllowed(boolean customLogAllowed){
        this.customLogAllowed = customLogAllowed;
    }
    public String getCustomLogFileName(){
        return customLogFileName;
    }
    public void setCustomLogFileName(String customLogFileName){
        this.customLogFileName = customLogFileName;
    }
    public String getCustomLogFormat(){
        return customLogFormat;
    }
    public void setCustomLogFormat(String customLogFormat){
        this.customLogFormat = customLogFormat;
    }
    public String getErrorLogMode(){
        return errorLogMode;
    }
    public void setErrorLogMode(String errorLogMode){
        this.errorLogMode = errorLogMode;
    }
    public String getErrorLogLocation(){
        return errorLogLocation;
    }
    public void setErrorLogLocation(String errorLogLocation){
        this.errorLogLocation = errorLogLocation;
    }
    public String getErrorLogLevel(){
        return errorLogLevel;
    }
    public void setErrorLogLevel(String errorLogLevel){
        this.errorLogLevel = errorLogLevel;
    }   
    public String getAccessFileName(){
        return accessFileName;
    }
    public void setAccessFileName(String accessFileName){
        this.accessFileName = accessFileName;
    }    
    public boolean getUserDirAllowed(){
        return userDirAllowed;
    }
    public void setUserDirAllowed(boolean userDirAllowed){
        this.userDirAllowed = userDirAllowed;
    }
    public String getUserDirPattern(){
        return userDirPattern;
    }
    public void setUserDirPattern(String userDirPattern){
        this.userDirPattern = userDirPattern;
    }
    public String getUserDirMode(){
        return userDirMode;
    }
    public void setUserDirMode(String userDirMode){
        this.userDirMode = userDirMode;
    }
    public String getUserDirUserList(){
        return userDirUserList;
    }
    public void setUserDirUserList(String userDirUserList){
        this.userDirUserList = userDirUserList;
    }
    public Map getDirectoryMap(){
        return directoryMap;
    }
    public void setDirectoryMap(Map directoryMap){
        this.directoryMap = directoryMap;
    }
	public String getUsedPort(){
		return usedPort;
	}
	public void setUsedPort(String usedPort){
		this.usedPort = usedPort;
	}

}
