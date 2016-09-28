/*
 *      Copyright (c) 2004 NEC Corporation
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
/**
 *
 */
public class SyslogCommonInfoBean {
    private static final String cvsid =
            "@(#) $Id: SyslogCommonInfoBean.java,v 1.1 2004/11/21 08:13:44 baiwq Exp $";

    private String logFile = "";
    private String viewLines = "2000";
    private String viewOrder = "new";
    private String searchWords = "";
    private String aroundLines = "0";
    private String containWords = "yes";
    private String caseSensitive = "no";
    private String displayEncoding = "";
    private String logType = "";
    private String logName = "";
    private String searchAction = "";
 
    /**
     * @return
     */
    public String getAroundLines() {
        return aroundLines;
    }

    /**
     * @return
     */
    public String getCaseSensitive() {
        return caseSensitive;
    }

    /**
     * @return
     */
    public String getContainWords() {
        return containWords;
    }

    /**
     * @return
     */
    public String getDisplayEncoding() {
        return displayEncoding;
    }

    /**
     * @return
     */
    public String getLogFile() {
        return logFile;
    }

    /**
     * @return
     */
    public String getLogName() {
        return logName;
    }

    /**
     * @return
     */
    public String getLogType() {
        return logType;
    }

    /**
     * @return
     */
    public String getSearchAction() {
        return searchAction;
    }

    /**
     * @return
     */
    public String getSearchWords() {
        return searchWords;
    }

    /**
     * @return
     */
    public String getViewLines() {
        return viewLines;
    }

    /**
     * @return
     */
    public String getViewOrder() {
        return viewOrder;
    }

    /**
     * @param string
     */
    public void setAroundLines(String string) {
        aroundLines = string;
    }

    /**
     * @param string
     */
    public void setCaseSensitive(String string) {
        caseSensitive = string;
    }

    /**
     * @param string
     */
    public void setContainWords(String string) {
        containWords = string;
    }

    /**
     * @param string
     */
    public void setDisplayEncoding(String string) {
        displayEncoding = string;
    }

    /**
     * @param string
     */
    public void setLogFile(String string) {
        logFile = string;
    }

    /**
     * @param string
     */
    public void setLogName(String string) {
        logName = string;
    }

    /**
     * @param string
     */
    public void setLogType(String string) {
        logType = string;
    }

    /**
     * @param string
     */
    public void setSearchAction(String string) {
        searchAction = string;
    }

    /**
     * @param string
     */
    public void setSearchWords(String string) {
        searchWords = string;
    }

    /**
     * @param string
     */
    public void setViewLines(String string) {
        viewLines = string;
    }

    /**
     * @param string
     */
    public void setViewOrder(String string) {
        viewOrder = string;
    }

}

