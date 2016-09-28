/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicRouteBean.java,v 1.2 2005/10/24 04:56:14 dengyp Exp $
 */


package com.nec.nsgui.model.entity.nic;

public class NicRouteBean {

    private String nicName;
    private String destination;
    private String gateway;
    private String source;
    public NicRouteBean() {

        nicName = "";
        destination = "";
        gateway = "";
        source = "";
    }

    public void setNicName(String value) {
        this.nicName = value;
    }

    public String getNicName() {
        return this.nicName;
    }

    /**
     * @return
     */
    public String getDestination() {
        return destination;
    }

    /**
     * @return
     */
    public String getGateway() {
        return gateway;
    }

    /**
     * @param string
     */
    public void setDestination(String string) {
        destination = string;
    }

    /**
     * @param string
     */
    public void setGateway(String string) {
        gateway = string;
    }

    /**
     * @return
     */
    public String getSource() {
        return source;
    }

    /**
     * @param string
     */
    public void setSource(String string) {
        source = string;
    }

}