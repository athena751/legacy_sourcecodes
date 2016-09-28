/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.ndmpv4;
public class DeviceInfoBean {
    private static final String cvsid =
        "@(#) $Id: DeviceInfoBean.java,v 1.2 2006/10/09 01:47:54 qim Exp $";
        	
    private String deviceType;
    private String deviceName;
    private String modelName;
    private String contrlNo;
    private String channelNo;
    private String id;
    private String lun;
    private String connectionType;
    private String wwnn;
    private String wwpn;
    private String protID;
       
    public String getDeviceType() {
        return deviceType;
    }
    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }
    public String getDeviceName() {
        return deviceName;
    }
    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }
    public String getModelName() {
        return modelName;
    }
    public void setModelName(String modelName) {
        this.modelName = modelName;
    }
    public String getContrlNo() {
        return contrlNo;
    }
    public void setContrlNo(String contrlNo) {
        this.contrlNo = contrlNo;
    }
    public String getChannelNo() {
        return channelNo;
    }
    public void setChannelNo(String channelNo) {
        this.channelNo = channelNo;
    }
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getLun() {
        return lun;
    }
    public void setLun(String lun) {
        this.lun = lun;
    }   
    public String getConnectionType() {
        return connectionType;
    }
    public void setConnectionType(String connectionType) {
        this.connectionType = connectionType;
    } 
    public String getWwnn() {
        return wwnn;
    }
    public void setWwnn(String wwnn) {
        this.wwnn = wwnn;
    }
    public String getWwpn() {
        return wwpn;
    }
    public void setWwpn(String wwpn) {
        this.wwpn = wwpn;
    }
    public String getProtID() {
        return protID;
    }
    public void setProtID(String protID) {
        this.protID = protID;
    }
}