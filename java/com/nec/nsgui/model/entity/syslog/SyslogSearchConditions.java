/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.syslog;

/**
 *
 */
public class SyslogSearchConditions {
    private static final String cvsid =
        "@(#) $Id: SyslogSearchConditions.java,v 1.2 2008/09/23 09:45:07 penghe Exp $";

    private SyslogCommonInfoBean commonInfo;
    private SyslogSystemSearchInfoBean systemlogSearchInfo;
    private SyslogCifsSearchInfoBean cifsSearchInfo;

    /**
    * @return
    */
    public SyslogCifsSearchInfoBean getCifsSearchInfo() {
        return this.cifsSearchInfo;
    }

    /**
    * @param currentPage
    */
    public void setCifsSearchInfo(SyslogCifsSearchInfoBean cifsSearchInfo) {
        this.cifsSearchInfo = cifsSearchInfo;
    }

    /**
    * @return
    */
    public SyslogSystemSearchInfoBean getSystemlogSearchInfo() {
        return this.systemlogSearchInfo;
    }

    /**
    * @param currentPage
    */
    public void setSystemlogSearchInfo(SyslogSystemSearchInfoBean systemlogSearchInfo) {
        this.systemlogSearchInfo = systemlogSearchInfo;
    }

    /**
     * @return
     */
    public SyslogCommonInfoBean getCommonInfo() {
        return this.commonInfo;
    }

    /**
    * @param currentPage
    */
    public void setCommonInfo(SyslogCommonInfoBean commonInfo) {
        this.commonInfo = commonInfo;
    }

}
