/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.serverprotect;

/**
 * @author chenbc
 *
 */
public class ServerProtectScanServerBean {
    private static final String cvsid = "@(#) $Id: ServerProtectScanServerBean.java,v 1.2 2007/03/23 06:35:44 wanghb Exp $";

    private String host = "";  
    private String interfaces = "";
    private String connectStatus = "";
    
    /**
     * @return Returns the host.
     */
    public String getHost() {
        return host;
    }
    /**
     * @param host The host to set.
     */
    public void setHost(String host) {
        this.host = host;
    }
    /**
     * @return Returns the interfaces.
     */
    public String getInterfaces() {
        return interfaces;
    }
    /**
     * @param interfaces The interfaces to set.
     */
    public void setInterfaces(String interfaces) {
        this.interfaces = interfaces;
    }
    /**
     * @return Returns the connectStatus.
     */
    public String getConnectStatus() {
        return connectStatus;
    }
    /**
     * @param connectStatus The connectStatus to set.
     */
    public void setConnectStatus(String connectStatus) {
        this.connectStatus = connectStatus;
    }
    
    
}
