/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.volume;

/**
 *
 */
public class VolumeAvailableNumberBean {
    private static final String cvsid =
        "@(#) $Id: VolumeAvailableNumberBean.java,v 1.1 2004/08/30 10:24:32 caoyh Exp $";    
    private String volumeNumber;
    private String ldCount;
    private String lvCount;
    /**
     * @return
     */
    public String getLdCount() {
        return ldCount;
    }

    /**
     * @return
     */
    public String getLvCount() {
        return lvCount;
    }

    /**
     * @return
     */
    public String getVolumeNumber() {
        return volumeNumber;
    }

    /**
     * @param string
     */
    public void setLdCount(String string) {
        ldCount = string;
    }

    /**
     * @param string
     */
    public void setLvCount(String string) {
        lvCount = string;
    }

    /**
     * @param string
     */
    public void setVolumeNumber(String string) {
        volumeNumber = string;
    }

}
