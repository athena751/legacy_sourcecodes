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
public class HTTPInfo extends SoapResponse{
	private static final String	cvsid = "@(#) $Id: HTTPInfo.java,v 1.2300 2003/11/24 00:54:41 nsadmin Exp $";

    private HTTPServerInfo mainServer = new HTTPServerInfo();
    private HTTPBasicInfo basicInfo = new HTTPBasicInfo();
    private Vector virtualHosts = new Vector();

    public HTTPServerInfo getMainServer(){
        return mainServer;
    }
    public void setMainServer(HTTPServerInfo mainServer){
        this.mainServer = mainServer;
    }
    public HTTPBasicInfo getBasicInfo(){
        return basicInfo;
    }
    public void setBasicInfo(HTTPBasicInfo basicInfo){
        this.basicInfo = basicInfo;
    }
    public Vector getVirtualHosts(){
        return virtualHosts;
    }
    public void setVirtualHosts(Vector virtualHosts){
        this.virtualHosts = virtualHosts;
    }

}
