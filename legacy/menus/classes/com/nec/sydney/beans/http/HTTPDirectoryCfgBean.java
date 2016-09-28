/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.http ;

import com.nec.sydney.beans.base.* ;
import com.nec.sydney.atom.admin.http.* ;
import com.nec.sydney.framework.tools.req2file.*;
import java.util.* ;

public class HTTPDirectoryCfgBean extends TemplateBean {

    private static final String cvsid = "@(#) $Id: HTTPDirectoryCfgBean.java,v 1.2302 2005/09/27 08:43:58 xingh Exp $";

    private static final String REDIRECT_URL = "../nas/http/httpsetdirdone.jsp" ;
    private HTTPDirectoryInfo directoryInfo ;
    private String oldVirtualHostName ;
    private String directory ;
    private String currentDirectory ;
    private String whichpage ;
    private String oldNickName = "" ;
    private String oldDirectory = "" ;
    private String newDirectory ;
    private String accessMode ;
    private String allowList = "";
    private String denyList = "";
    private String isVirtualAdd = "";
/*    private String optionScript ;
    private String htaccessScript ;
*/

    public HTTPDirectoryCfgBean() {
        directoryInfo = new HTTPDirectoryInfo() ;
    }

    public void onDisplay() throws Exception {

    }

    public void onAddDir() throws Exception {
        oldDirectory = "" ;
        directoryInfo = HTTPSOAPClient.getDirectoryInfo(session,getMyNum(), oldNickName, oldDirectory, target) ;
/*        optionScript = directoryInfo.getDirectoryOptions() ;
        htaccessScript = directoryInfo.getAllowOverwriteOptions() ;
*/
    }

    public void onEditDir() throws Exception {
        oldDirectory = directory ;
        HTTPDirectoryInfo newDirectoryInfo = HTTPSOAPClient.getDirectoryInfo(session,getMyNum(), oldNickName, oldDirectory, target) ;
        TreeMap theDirectories = (TreeMap)session.getAttribute(HTTPConstants.SESSION_DIRECTORIES) ;
        if (theDirectories!=null && theDirectories.containsKey(oldDirectory)) {
            directoryInfo = (HTTPDirectoryInfo)theDirectories.get(oldDirectory) ;
            directoryInfo.setDirectoryOptions(newDirectoryInfo.getDirectoryOptions()) ;
            directoryInfo.setAllowOverwriteOptions(newDirectoryInfo.getAllowOverwriteOptions()) ;
        } else {
            directoryInfo = newDirectoryInfo ;
        }
/*        optionScript = directoryInfo.getDirectoryOptions() ;
        htaccessScript = directoryInfo.getAllowOverwriteOptions() ;
*/
    }

    public void onSubmitDir() throws Exception {
        HTTPDirectoryInfo theDirectoryInfo = new HTTPDirectoryInfo() ;
        theDirectoryInfo.setDirectoryAccessMode(accessMode) ;
        if (!accessMode.equals("")) {
            theDirectoryInfo.setDirectoryAccessAllowList(allowList) ;
            theDirectoryInfo.setDirectoryAccessDenyList(denyList) ;
        }
/*
        theDirectoryInfo.setDirectoryOptions(optionScript) ;
        theDirectoryInfo.setAllowOverwriteOptions(htaccessScript) ;
*/

        TreeMap inputValues = new TreeMap() ;
        ParameterFileMaker.makeParameterMap(request,inputValues) ;
        theDirectoryInfo.setDynamicInfo(inputValues) ;

        TreeMap theDirectories = (TreeMap)session.getAttribute(HTTPConstants.SESSION_DIRECTORIES) ;
        if (theDirectories==null) {
            theDirectories = new TreeMap() ;
            theDirectoryInfo.setDirectory(oldDirectory) ;
        } else {
            Hashtable tmDirectory = new Hashtable();
            String serverType = oldNickName.equals("")?"mainServer":"virtualHost";;
            if (oldDirectory.equals("")) {
                tmDirectory.put(newDirectory, theDirectoryInfo);
                addDirectory(theDirectories, newDirectory, theDirectoryInfo);
            } else {
                HTTPDirectoryInfo tempDir = new HTTPDirectoryInfo(theDirectoryInfo);
                tempDir.setDirectory(oldDirectory);
                tmDirectory.put(newDirectory, tempDir);
                delDirectory(theDirectories, oldDirectory);
                addDirectory(theDirectories, newDirectory, theDirectoryInfo);
            }
            Vector vDir = new Vector();
            vDir.add(tmDirectory);
            HTTPSOAPClient.setDirectoryInfo(target,
                                                  getMyNum(),
                                                  serverType,
                                                  vDir,
                                                  oldNickName);
        }
        theDirectories.put(newDirectory,theDirectoryInfo) ;
        session.setAttribute(HTTPConstants.SESSION_DIRECTORIES,theDirectories) ;

        
        if (oldDirectory.equals("")) {
            session.setAttribute("http_directory", newDirectory);
            oldNickName = oldNickName.equals("#")?"-":oldNickName;
            setRedirectUrl(REDIRECT_URL + "?setType=" + HTTPConstants.SET_DIR_ADD +
            //                "&directory=" + newDirectory +
                            "&prePage=" + whichpage + "&oldNickName=" + oldNickName );
        } else {
            session.setAttribute("http_directory", oldDirectory + ":" + newDirectory);
            oldNickName = oldNickName.equals("#")?"-":oldNickName;
            setRedirectUrl(REDIRECT_URL + "?setType=" + HTTPConstants.SET_DIR_EDIT +
             //               "&directory=" + oldDirectory + ":" + newDirectory +
                            "&prePage=" + whichpage + "&oldNickName=" + oldNickName );
        }
    }

    public void onDelDir() throws Exception {
        TreeMap theDirectories = (TreeMap)session.getAttribute(HTTPConstants.SESSION_DIRECTORIES) ;

        directoryInfo = new HTTPDirectoryInfo();
        directoryInfo.setDirectory(HTTPConstants.NO_DIRECTORY);
        Hashtable tmDirectory = new Hashtable();
        String serverType = oldNickName.equals("")?"mainServer":"virtualHost";

        tmDirectory.put(oldDirectory, directoryInfo);
        Vector vDir = new Vector();
        vDir.add(tmDirectory);
        HTTPSOAPClient.setDirectoryInfo(target,
                                          getMyNum(),
                                          serverType,
                                          vDir,
                                          oldNickName);
        if (theDirectories == null) {
            theDirectories = new TreeMap() ;
            theDirectories.put(oldDirectory, directoryInfo) ;
        } else {
            delDirectory(theDirectories, oldDirectory);
        }
        session.setAttribute(HTTPConstants.SESSION_DIRECTORIES,theDirectories) ;
        session.setAttribute("http_directory", oldDirectory);
        oldNickName = oldNickName.equals("#")?"-":oldNickName;
        setRedirectUrl(REDIRECT_URL + "?setType=" + HTTPConstants.SET_DIR_DEL + 
        //                "&directory=" + oldDirectory +
                        "&prePage=" + whichpage + "&oldNickName=" + oldNickName);
    }

    public void addDirectory(Map theDirectories, String newDirectory, HTTPDirectoryInfo theDirectoryInfo) {
        if (theDirectories.containsKey(newDirectory)) {
            theDirectoryInfo.setDirectory(newDirectory);
            theDirectories.remove(newDirectory) ;
        } else {
            Iterator it = theDirectories.keySet().iterator();
            boolean isOld = false;
            String tmp = "";
            while (it.hasNext()) {
                tmp = (String)it.next();
                String dir = ((HTTPDirectoryInfo)(theDirectories.get(tmp))).getDirectory();
                if (dir.equals(newDirectory)) {
                    isOld = true;
                    break;
                }
            }
            if (isOld) {
                ((HTTPDirectoryInfo)(theDirectories.get(tmp))).setDirectory("");
                theDirectoryInfo.setDirectory(newDirectory);
            }
        }
    }

    public void delDirectory(Map theDirectories, String oldDirectory) {
        HTTPDirectoryInfo info = new HTTPDirectoryInfo();
        info.setDirectory(HTTPConstants.NO_DIRECTORY);
        if (theDirectories.containsKey(oldDirectory)) {
            if (((HTTPDirectoryInfo)theDirectories.get(oldDirectory)).getDirectory().equals("")) {
                theDirectories.remove(oldDirectory);
            } else {
                String dirTemp = ((HTTPDirectoryInfo)theDirectories.get(oldDirectory)).getDirectory() ;
                theDirectories.remove(oldDirectory) ;
                theDirectories.put(dirTemp,info) ;
            }
        } else {
            theDirectories.put(oldDirectory,info) ;
        }
    }

    public void setOldVirtualHostName(String oldVirtualHostName) {
        this.oldVirtualHostName = oldVirtualHostName;
    }

    public void setDirectory(String directory) {
        this.directory = directory;
    }

    public void setCurrentDirectory(String currentDirectory) {
        this.currentDirectory = currentDirectory;
    }

    public void setWhichpage(String whichpage) {
        this.whichpage = whichpage;
    }

    public void setOldNickName(String oldNickName) {
        this.oldNickName = oldNickName;
    }

    public void setOldDirectory(String oldDirectory) {
        this.oldDirectory = oldDirectory;
    }

    public void setNewDirectory(String newDirectory) {
        this.newDirectory = newDirectory;
    }

    public void setAccessMode(String accessMode) {
        this.accessMode = accessMode;
    }

    public void setAllowList(String allowList) {
        this.allowList = allowList;
    }

    public void setDenyList(String denyList) {
        this.denyList = denyList;
    }
/*
    public void setOptionScript(String optionScript) {
        this.optionScript = optionScript;
    }

    public void setHtaccessScript(String htaccessScript) {
        this.htaccessScript = htaccessScript;
    }
*/

    public HTTPDirectoryInfo getDirectoryInfo() {
        return directoryInfo ;
    }

    public String getOldDirectory() {
        return oldDirectory ;
    }

    public String getWhichPage() {
        return whichpage ;
    }

    public String getOldNickName() {
        return oldNickName ;
    }

    public String getOldDirectoryList() {
        return currentDirectory ;
    }

    public String getNewDirectory() {
        return newDirectory ;
    }

    public String getIsVirtualAdd(){
        return this.isVirtualAdd;
    }

    public void setIsVirtualAdd(String s){
        this.isVirtualAdd = s;
    }
/*
    public String getOptionScript() {
        return optionScript ;
    }

    public String getHtaccessScript() {
        return htaccessScript ;
    }
*/

}