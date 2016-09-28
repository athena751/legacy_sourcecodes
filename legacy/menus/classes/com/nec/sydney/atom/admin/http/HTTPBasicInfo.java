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
public class HTTPBasicInfo extends SoapResponse implements HTTPConstants{
	private static final String	cvsid = "@(#) $Id: HTTPBasicInfo.java,v 1.2300 2003/11/24 00:54:41 nsadmin Exp";

    private boolean serviceStatus = false;
    private boolean httpdStatus = false;
    private String ports = "80";
    private String selectableFunctions = "";
    private String defaultOptions = "";
	private String usedPort = "";
    private Map dynamicInfo = new Hashtable();

    public boolean getServiceStatus(){
        return serviceStatus;
    }
    public boolean getHttpdStatus(){
        return httpdStatus;
    }
    public void setHttpdStatus(boolean httpdStatus){
        this.httpdStatus = httpdStatus;
    }
    public void setServiceStatus(boolean serviceStatus){
        this.serviceStatus = serviceStatus;
    }
    public String getPorts(){
        return ports;
    }
    public void setPorts(String ports){
        this.ports = ports;
    }
    public String getSelectableFunctions(){
        return selectableFunctions;
    }
    public void setSelectableFunctions(String selectableFunctions){
        this.selectableFunctions = selectableFunctions;
    }
    public String getDefaultOptions(){
        return defaultOptions;
    }
    public void setDefaultOptions(String defaultOptions){
        this.defaultOptions = defaultOptions;
    }
    public Map getDynamicInfo(){
        return dynamicInfo;
    }
    public void setDynamicInfo(Map dynamicInfo){
        this.dynamicInfo = dynamicInfo;
    }
	public String getUsedPort(){
		return usedPort;
	}
	public void setUsedPort(String usedPort){
		this.usedPort = usedPort;
	}

}
