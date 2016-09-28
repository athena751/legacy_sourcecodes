/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;
  
/**
 *
 */
public class DeviceInfoBean {
    private static final String cvsid =
               "@(#) $Id: DeviceInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private String sMountPoint;
    private double usedRate;
    private double total;
    private double used;
    private double available;
    private String sType;
    private String sDevice;
    
    
    /**
     * @return
     */
    public double getAvailable() {
        return available;
    }

    /**
     * @return
     */
    public String getSDevice() {
        return sDevice;
    }

    /**
     * @return
     */
    public String getSMountPoint() {
        return sMountPoint;
    }

    /**
     * @return
     */
    public String getSType() {
        return sType;
    }

    /**
     * @return
     */
    public double getTotal() {
        return total;
    }

    /**
     * @return
     */
    public double getUsed() {
        return used;
    }

    /**
     * @return
     */
    public double getUsedRate() {
        return usedRate;
    }

    /**
     * @param d
     */
    public void setAvailable(double d) {
        available = d;
    }

    /**
     * @param string
     */
    public void setSDevice(String string) {
        sDevice = string;
    }

    /**
     * @param string
     */
    public void setSMountPoint(String string) {
        sMountPoint = string;
    }

    /**
     * @param string
     */
    public void setSType(String string) {
        sType = string;
    }

    /**
     * @param d
     */
    public void setTotal(double d) {
        total = d;
    }

    /**
     * @param d
     */
    public void setUsed(double d) {
        used = d;
    }

    /**
     * @param d
     */
    public void setUsedRate(double d) {
        usedRate = d;
    }

}
