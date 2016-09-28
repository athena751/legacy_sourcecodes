/*
 *      Copyright (c) 2004-2008 NEC Corporation
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

public class SyslogHttpLogInfoBean {
    private static final String cvsid =
            "@(#) $Id: SyslogHttpLogInfoBean.java,v 1.2 2008/05/09 05:04:02 hetao Exp $";

    private String logLabel = "";
    private String logFileName = "";
    private String fileSize = "";
    private String fileSizeForDisplay = ""; 

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileSizeForDisplay() {
		return fileSizeForDisplay;
	}

	public void setFileSizeForDisplay(String fileSizeForDisplay) {
		this.fileSizeForDisplay = fileSizeForDisplay;
	}

	/**
     * @return
     */
    public String getLogFileName() {
        return logFileName;
    }

    /**
     * @return
     */
    public String getLogLabel() {
        return logLabel;
    }

    /**
     * @param string
     */
    public void setLogFileName(String string) {
        logFileName = string;
    }

    /**
     * @param string
     */
    public void setLogLabel(String string) {
        logLabel = string;
    }

}

