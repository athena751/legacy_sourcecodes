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

public class SampleInfoBean {
    private static final String cvsid =
            "@(#) $Id: SampleInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";

    private String     sample;          //Flag signing whether sample
    private String     sampleInterval;  //It is unit of sampling
    private String     sampleUnit;      //It is the interval of sampling


    /**
     * @return
     */
    public String getSample() {
        return sample;
    }

    /**
     * @return
     */
    public String getSampleInterval() {
        return sampleInterval;
    }

    /**
     * @return
     */
    public String getSampleUnit() {
        return sampleUnit;
    }

    /**
     * @param string
     */
    public void setSample(String string) {
        sample = string;
    }

    /**
     * @param string
     */
    public void setSampleInterval(String string) {
        sampleInterval = string;
    }

    /**
     * @param string
     */
    public void setSampleUnit(String string) {
        sampleUnit = string;
    }

}