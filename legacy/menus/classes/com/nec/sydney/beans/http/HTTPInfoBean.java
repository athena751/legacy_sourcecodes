/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.beans.http ;

import com.nec.sydney.beans.base.* ;
import com.nec.sydney.framework.* ;
import com.nec.sydney.atom.admin.http.* ;
import com.nec.sydney.net.soap.*;
import java.util.* ;
import com.nec.nsgui.action.base.NSActionUtil;

public class HTTPInfoBean extends TemplateBean {

    private static final String cvsid = "@(#) $Id: HTTPInfoBean.java,v 1.2300 2003/11/24 00:54:50 nsadmin Exp";
    
    private static final String MAIN_SVR = "mainServer" ;
    private static final String VTL_HOST = "virtualHost" ;
    
    private HTTPBasicInfo basicInfo ;
    private HTTPServerInfo mainServerInfo ;
    private Vector virtualHostInfo ;

    public HTTPInfoBean() {
        basicInfo = new HTTPBasicInfo() ;
        mainServerInfo = new HTTPServerInfo() ;
        //virtualHostInfo = new Vector() ;
    }

    public void onDisplay() throws Exception {
        String myNum = getMyNum();
        if(myNum == null){
            myNum = "0";   
        }
        String infoLocation = request.getParameter("infoLocation");
        if (infoLocation == null || infoLocation.equals("")){
            infoLocation = "etc";
            if(!NSActionUtil.isNsview(request)){
	            String fnode = Soap4Cluster.whoIsMyFriend(target);
	            if (fnode != null){
	                HTTPSOAPClient.getHTTPInfo(session,myNum, fnode, infoLocation);
	            }
	        }
        }
        HTTPInfo theHttpInfo = new HTTPInfo() ;
        if(NSActionUtil.isNsview(request)){
        	theHttpInfo = HTTPSOAPClient.getHTTPInfo(session,myNum, target, infoLocation, "isNsview");
        }else{
        	theHttpInfo = HTTPSOAPClient.getHTTPInfo(session,myNum,target, infoLocation);
        }
        basicInfo = theHttpInfo.getBasicInfo() ;
        mainServerInfo = theHttpInfo.getMainServer() ;
        virtualHostInfo = theHttpInfo.getVirtualHosts() ;
        changeValues() ;
    }
    private void changeValues() {
        basicInfo.setPorts(changeList(basicInfo.getPorts())) ;
        
        mainServerInfo.setUserDirUserList(changeUserList(mainServerInfo.getUserDirUserList())) ;
        mainServerInfo.setTransferLogLocation(changeLocation(mainServerInfo.getTransferLogMode(), mainServerInfo.getTransferLogLocation(), MAIN_SVR));
        mainServerInfo.setCustomLogFormat(changeFormat(mainServerInfo.getCustomLogAllowed(), mainServerInfo.getCustomLogFormat(), MAIN_SVR));
        mainServerInfo.setErrorLogLocation(changeLocation(mainServerInfo.getErrorLogMode(), mainServerInfo.getErrorLogLocation(), MAIN_SVR));
        
        Map theDirectoryMap = mainServerInfo.getDirectoryMap() ;
        Iterator theDirectoryItr = theDirectoryMap.keySet().iterator();
        HTTPDirectoryInfo theDirectory ;
        while (theDirectoryItr.hasNext()) {
            theDirectory = (HTTPDirectoryInfo)theDirectoryMap.get((String)theDirectoryItr.next()) ;
            theDirectory.setDirectoryAccessAllowList(changeList(theDirectory.getDirectoryAccessAllowList())) ;
            theDirectory.setDirectoryAccessDenyList(changeList(theDirectory.getDirectoryAccessDenyList())) ;
            theDirectoryMap.put(theDirectory.getDirectory(),theDirectory) ;
        }
        mainServerInfo.setDirectoryMap(theDirectoryMap) ;
        
        HTTPServerInfo theServerInfo ;
        for (int i=0; i<virtualHostInfo.size(); i++) {
            theServerInfo = (HTTPServerInfo)virtualHostInfo.get(i) ;
            theServerInfo.setUsedIPAddrs(changeIPAddrs(theServerInfo.getUsedIPAddrsMode(), theServerInfo.getUsedIPAddrs())) ;
            theServerInfo.setTransferLogLocation(changeLocation(theServerInfo.getTransferLogMode(), theServerInfo.getTransferLogLocation(), VTL_HOST));
            theServerInfo.setCustomLogFormat(changeFormat(theServerInfo.getCustomLogAllowed(), theServerInfo.getCustomLogFormat(), VTL_HOST));
            theServerInfo.setErrorLogLocation(changeLocation(theServerInfo.getErrorLogMode(), theServerInfo.getErrorLogLocation(), VTL_HOST));
        }
    }

    private String changeList(String oldStr) {
        if (oldStr== null || oldStr.trim().equals("")) {
            return "&nbsp;" ;
        }
        String strTemp ;
        String[] strArray = oldStr.trim().split(" ") ;
        if (strArray.length>3) {
            strTemp = strArray[0] + ", " + strArray[1] + ", " + strArray[2] + ", ..." ;
        } else {
            strTemp = oldStr.trim().replaceAll(" ", ", ") ;
        }
        return strTemp ;
    }
    
    private String changeLocation(String mode, String location, String valueType) {
        if (mode.equals(HTTPConstants.TRANSFERLOGMODE_STANDARD)) {
            return NSMessageDriver.getInstance().getMessage(session,"nas_http/server/th_standard");
        } else if (mode.equals(HTTPConstants.ERRORLOGMODE_SYSLOG)) {
            return HTTPConstants.ERRORLOGMODE_SYSLOG ;
        } else {
            if (valueType.equals(VTL_HOST)) {
                return NSMessageDriver.getInstance().getMessage(session,"nas_http/server/th_user");
            } else {
                return location ;
            }
        }
    }
    
    private String changeFormat(boolean allowed, String customLogFormat, String valueType) {
        if (allowed) {
            if (valueType.equals(VTL_HOST)) {
                return NSMessageDriver.getInstance().getMessage(session,"nas_http/server/th_custom_host");
            } else {
                return customLogFormat ;
            }
        } else {
            return NSMessageDriver.getInstance().getMessage(session,"nas_http/server/th_standard");
        }
    }
    
    private String changeIPAddrs(String IPAddrsMode, String IPAddrs) {
        if (IPAddrsMode.equals(HTTPConstants.USEDIPADDSMODE_ALL)) {
            return NSMessageDriver.getInstance().getMessage(session,"nas_http/server/th_all");
        } else {
            if (IPAddrs== null || IPAddrs.trim().equals("")) {
                return "&nbsp;" ;
            }
            String strTemp ;
            String[] strArray = IPAddrs.trim().split(" ") ;
            if (strArray.length>3) {
                strTemp = strArray[0] + "<br>" + strArray[1] + "<br> " + strArray[2] + "<br>..." ;
            } else {
                strTemp = IPAddrs.trim().replaceAll(" ", "<br>") ;
            }
            return strTemp ;
        }   

    }
    
    public HTTPBasicInfo getBasicInfo() {
        return basicInfo ;
    }
    
    public HTTPServerInfo getMainServerInfo() {
        return mainServerInfo ;
    }
    
    public Vector getVirtualHostInfo() {
        return virtualHostInfo ;
    }
    public void onDoConfig() throws Exception{
        SoapResponse sr = HTTPSOAPClient.setAllInfo(getMyNum(), target);
        if (sr.isSuccessful()){
            String fnode = Soap4Cluster.whoIsMyFriend(target);
            if (fnode != null) {
                sr = HTTPSOAPClient.setAllInfo(getMyNum(), fnode);
            }
        }
        if (!sr.isSuccessful()){
            if (sr.getErrorCode() == HTTPConstants.ERRORCODE_PORT_USED){
                super.setMsg(NSMessageDriver.getInstance()
                        .getMessage(session,"common/alert/failed") + "\\r\\n"
                        + NSMessageDriver.getInstance()
                        .getMessage(session,"nas_http/alert/port_been_used"));
            }else{
                throw new NSException(sr.getErrorMessage());
            }
        } else {
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
        }
        setRedirectUrl("../nas/http/httpinfo.jsp");
    }
    
    private String changeUserList(String list){
        int count = 0;
        StringBuffer sb = new StringBuffer();
        if (list == null || list.trim().equals("")){
            return "&nbsp;";
        }
        boolean inQuot = false;
        String tempUser = "";
        boolean userEnd = false;
        for(int i = 0; i < list.length(); i++){
            if (inQuot){
                if (list.charAt(i) == '\"'){
                    userEnd = true;
                    inQuot = false;
                }else{
                    userEnd = false;
                    tempUser = tempUser + list.charAt(i);
                }
            }else{
                if (list.charAt(i) == '\"'){
                    userEnd = false;
                    inQuot = true;
                }else if (list.charAt(i)==' '){
                    userEnd = true;
                }else{
                    userEnd = false;
                    tempUser = tempUser + list.charAt(i);
                }
            }
            if (i == list.length() - 1){
                userEnd = true;
            }
            if (userEnd && !tempUser.equals("")){
                if(count < 3){
                    count++;
                    sb.append(tempUser+",");
                }else{
                    sb.append("...");
                    break;
                }
                tempUser = "";
            }
        }
        String dispString = sb.toString();
        if (dispString.endsWith(",")){
            dispString = dispString.substring(0,dispString.length()-1);   
        }
        return dispString;    
    }
}