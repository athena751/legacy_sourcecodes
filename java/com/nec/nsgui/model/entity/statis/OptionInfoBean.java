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

public class OptionInfoBean {
    private static final String cvsid ="@(#) $Id: OptionInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";

    private TimeInfoBean fromTimeInfo = new TimeInfoBean();
    private TimeInfoBean toTimeInfo = new TimeInfoBean();
    private SampleInfoBean sampleInfo = new SampleInfoBean();

    /**
     * @return
     */
    public TimeInfoBean getFromTimeInfo() {
        return fromTimeInfo;
    }

    /**
     * @return
     */
    public SampleInfoBean getSampleInfo() {
        return sampleInfo;
    }

    /**
     * @return
     */
    public TimeInfoBean getToTimeInfo() {
        return toTimeInfo;
    }

    /**
     * @param bean
     */
    public void setFromTimeInfo(TimeInfoBean bean) {
        fromTimeInfo = bean;
    }

    /**
     * @param bean
     */
    public void setSampleInfo(SampleInfoBean bean) {
        sampleInfo = bean;
    }

    /**
     * @param bean
     */
    public void setToTimeInfo(TimeInfoBean bean) {
        toTimeInfo = bean;
    }

}