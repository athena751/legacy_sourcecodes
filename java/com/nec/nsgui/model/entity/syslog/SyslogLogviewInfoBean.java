/*
 *      Copyright (c) 2004-2006 NEC Corporation
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
public class SyslogLogviewInfoBean {
    private static final String cvsid =
        "@(#) $Id: SyslogLogviewInfoBean.java,v 1.2 2006/07/07 01:40:44 fengmh Exp $";

    private String currentPage = "1";
    private String pageCount = "0";
    private String downloadFileName = "";
    private String displayEncoding = "";
    private String logContents = "";

    /**
     * @return
     */
    public String getLogContents() {
        return this.logContents;
    }

    /**
    * @param currentPage
    */
    public void setLogContents(String logContents) {
        this.logContents = logContents;
    }

    /**
     * @return
     */
    public String getDisplayEncoding() {
        return this.displayEncoding;
    }

    /**
    * @param currentPage
    */
    public void setDisplayEncoding(String displayEncoding) {
        this.displayEncoding = displayEncoding;
    }

    /**
     * @return
     */
    public String getDownloadFileName() {
        return this.downloadFileName;
    }

    /**
    * @param currentPage
    */
    public void setDownloadFileName(String downloadFileName) {
        this.downloadFileName = downloadFileName;
    }

    /**
     * @return
     */
    public String getCurrentPage() {
        return this.currentPage;
    }

    /**
    * @param currentPage
    */
    public void setCurrentPage(String currentPage) {
        this.currentPage = currentPage;
    }

    /**
     * @return
     */
    public String getPageCount() {
        return this.pageCount;
    }

    /**
    * @param currentPage
    */
    public void setPageCount(String pageCount) {
        this.pageCount = pageCount;
    }

}
