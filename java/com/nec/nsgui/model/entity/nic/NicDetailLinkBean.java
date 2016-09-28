/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicDetailLinkBean.java,v 1.2 2005/10/24 04:56:14 dengyp Exp $
 */
package com.nec.nsgui.model.entity.nic;



public class NicDetailLinkBean{
    private String nicName = "";
    private String ifStatus = "";
    private String linkStatus = "";
    private String autoNego = "";
    private String speed = "";
    private String communicationStatus = "";
    private String active = "--";
    private String macAddress = "--";
    private static final String cvsid = "@(#) $Id: NicDetailLinkBean.java,v 1.2 2005/10/24 04:56:14 dengyp Exp $";    

    public String getNicName() {
        return nicName;
    }
    public void setNicName(String string) {
        nicName = string;
    }

    public String getIfStatus() {
        return ifStatus;
    }
    public void setIfStatus(String string) {
        ifStatus = string;
    }

    public String getLinkStatus() {
        return linkStatus;
    }
    public void setLinkStatus(String string) {
        linkStatus = string;
    }

    public String getAutoNego() {
        return autoNego;
    }
    public void setAutoNego(String string) {
        autoNego = string;
    }

    public String getSpeed() {
        return speed;
    }
    public void setSpeed(String string) {
        speed = string;
    }

    public String getCommunicationStatus() {
        return communicationStatus;
    }
    public void setCommunicationStatus(String string) {
        communicationStatus = string;
    }

    /**
     * @return
     */
    public String getActive() {
        return active;
    }

    /**
     * @return
     */
    public String getMacAddress() {
        return macAddress;
    }

    /**
     * @param string
     */
    public void setActive(String string) {
        active = string;
    }

    /**
     * @param string
     */
    public void setMacAddress(String string) {
        macAddress = string;
    }

}