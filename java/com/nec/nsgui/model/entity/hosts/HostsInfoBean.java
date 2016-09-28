/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: HostsInfoBean.java,v 1.2 2006/05/22 07:57:58 dengyp Exp $
 */


package com.nec.nsgui.model.entity.hosts;

public class HostsInfoBean {

    private String ipAddress = "";
    private String host = "";
    private String alias = "";

    public void setIpAddress(String value) {
        this.ipAddress= value;
    }

    public String getIpAddress() {
        return this.ipAddress;
    }

    /**
     * @return
     */
    public String getHost() {
        return host;
    }

    /**
     * @return
     */
    public String getAlias() {
        return alias;
    }

    /**
     * @param string
     */
    public void setHost(String string) {
        host = string;
    }

    /**
     * @param string
     */
    public void setAlias(String string) {
        alias = string;
    }
  
}