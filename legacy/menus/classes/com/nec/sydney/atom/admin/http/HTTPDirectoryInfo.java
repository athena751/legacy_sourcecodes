/*
 *      Copyright (c) 2001 NEC Corporation
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
public class HTTPDirectoryInfo extends SoapResponse implements HTTPConstants{
	private static final String	cvsid = "@(#) $Id: HTTPDirectoryInfo.java,v 1.2300 2003/11/24 00:54:41 nsadmin Exp $";

    private String directory = "";
    private String directoryAccessMode = ALL_ALLOW;
    private String directoryAccessAllowList = "";
    private String directoryAccessDenyList = "";
    private String directoryOptions = "";
    private String allowOverwriteOptions = "";
    private Map dynamicInfo = new Hashtable();

    public HTTPDirectoryInfo(HTTPDirectoryInfo obj){
        this.directory = obj.getDirectory();
        this.directoryAccessMode = obj.getDirectoryAccessMode();
        this.directoryAccessAllowList = obj.getDirectoryAccessAllowList();
        this.directoryAccessDenyList = obj.getDirectoryAccessDenyList();
        this.directoryOptions = obj.getDirectoryOptions();
        this.allowOverwriteOptions = obj.getAllowOverwriteOptions();
        this.dynamicInfo = new Hashtable(obj.getDynamicInfo());

    }

    public HTTPDirectoryInfo(){
    }

    public String getDirectory(){
        return directory;
    }
    public void setDirectory(String directory){
        this.directory = directory;
    }
    public String getDirectoryAccessMode(){
        return directoryAccessMode;
    }
    public void setDirectoryAccessMode(String directoryAccessMode){
        this.directoryAccessMode = directoryAccessMode;
    }
    public String getDirectoryAccessAllowList(){
        return directoryAccessAllowList;
    }
    public void setDirectoryAccessAllowList(String directoryAccessAllowList){
        this.directoryAccessAllowList = directoryAccessAllowList;
    }
    public String getDirectoryAccessDenyList(){
        return directoryAccessDenyList;
    }
    public void setDirectoryAccessDenyList(String directoryAccessDenyList){
        this.directoryAccessDenyList = directoryAccessDenyList;
    }
    public String getDirectoryOptions(){
        return directoryOptions;
    }
    public void setDirectoryOptions(String directoryOptions){
        this.directoryOptions = directoryOptions;
    }
    public String getAllowOverwriteOptions(){
        return allowOverwriteOptions;
    }
    public void setAllowOverwriteOptions(String allowOverwriteOptions){
        this.allowOverwriteOptions = allowOverwriteOptions;
    }
    public Map getDynamicInfo(){
        return dynamicInfo;
    }
    public void setDynamicInfo(Map m){
        this.dynamicInfo = m;
    }

}
