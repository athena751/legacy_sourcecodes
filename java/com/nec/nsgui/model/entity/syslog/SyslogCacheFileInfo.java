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
public class SyslogCacheFileInfo {

    private static final String cvsid =
        "@(#) $Id: SyslogCacheFileInfo.java,v 1.3 2006/07/05 08:48:07 fengmh Exp $";

    private String logFileName = "";
    private long totalLine = 0;
    private String errorType = "";
    
    public String getLogFileName() {
        return logFileName;
    }
    
    public void setLogFileName(String logFileName) {
        this.logFileName = logFileName;
    }
    
    public long getTotalLine() {
        return totalLine;
    }
    
    public void setTotalLine(long totalLine) {
        this.totalLine = totalLine;
    }

    public String getErrorType() {
        return errorType;
    }
    

    public void setErrorType(String errorType) {
        this.errorType = errorType;
    }
}
