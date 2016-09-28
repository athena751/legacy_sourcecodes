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
public class SyslogLogFileInfo {

    private static final String cvsid =
        "@(#) $Id: SyslogLogFileInfo.java,v 1.2 2008/05/09 05:04:52 hetao Exp $";

    private String fileName;
    private String dateString;
    private String timeString;
    private String fileSize;
    private String fileSizeForDisplay = "";

    public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	/**
     * @return
     */
    public String getDateString() {
        return dateString;
    }

    /**
     * @return
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * @return
     */
    public String getTimeString() {
        return timeString;
    }

    /**
     * @param string
     */
    public void setDateString(String string) {
        dateString = string;
    }

    /**
     * @param string
     */
    public void setFileName(String string) {
        fileName = string;
    }

    /**
     * @param string
     */
    public void setTimeString(String string) {
        timeString = string;
    }

	public String getFileSizeForDisplay() {
		return fileSizeForDisplay;
	}

	public void setFileSizeForDisplay(String fileSizeForDisplay) {
		this.fileSizeForDisplay = fileSizeForDisplay;
	}

}
