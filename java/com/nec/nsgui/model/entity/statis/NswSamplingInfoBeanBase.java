/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.statis;

public class NswSamplingInfoBeanBase{
    private static final String cvsid ="@(#) $Id: NswSamplingInfoBeanBase.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private String indexID;
    private String id;
    private Boolean samplingStatus;
    private String interval;
    private String period;
    private String size;
    /**
     * @return
     */
    public String getId() {
        return id;
    }

    /**
     * @return
     */
    public String getIndexID() {
        return indexID;
    }

    /**
     * @return
     */
    public String getInterval() {
        return interval;
    }

    /**
     * @return
     */
    public String getPeriod() {
        return period;
    }

    /**
     * @return
     */
    public Boolean getSamplingStatus() {
        return samplingStatus;
    }

    /**
     * @param string
     */
    public void setId(String string) {
        id = string;
    }

    /**
     * @param string
     */
    public void setIndexID(String string) {
        indexID = string;
    }

    /**
     * @param string
     */
    public void setInterval(String string) {
        interval = string;
    }

    /**
     * @param string
     */
    public void setPeriod(String string) {
        period = string;
    }

    /**
     * @param boolean1
     */
    public void setSamplingStatus(Boolean boolean1) {
        samplingStatus = boolean1;
    }

    /**
     * @return
     */
    public String getSize() {
        return size;
    }

    /**
     * @param string
     */
    public void setSize(String string) {
        size = string;
    }

}