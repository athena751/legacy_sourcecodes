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
import java.util.*;

public class SyslogCifsLogInfoBean {
    private static final String cvsid =
            "@(#) $Id: SyslogCifsLogInfoBean.java,v 1.3 2008/05/09 05:03:07 hetao Exp $";

    private String computerName = "";
    private String accessLogFile = "";
    private String encoding = "";
    private String fileExist = "";
    private List rotateLogFiles = new ArrayList();
    private String needDisplayTime = "false";
    private String fileSize = "";
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
    public String getAccessLogFile() {
        return accessLogFile;
    }

    /**
     * @return
     */
    public String getComputerName() {
        return computerName;
    }

    /**
     * @param string
     */
    public void setAccessLogFile(String string) {
        accessLogFile = string;
    }

    /**
     * @param string
     */
    public void setComputerName(String string) {
        computerName = string;
    }

    /**
     * @return
     */
    public String getEncoding() {
        return encoding;
    }

    /**
     * @param string
     */
    public void setEncoding(String string) {
        encoding = string;
    }

    /**
     * @return
     */
    public String getFileExist() {
        return fileExist;
    }

    /**
     * @param string
     */
    public void setFileExist(String string) {
        fileExist = string;
    }

	public List getRotateLogFiles() {
		return rotateLogFiles;
	}

	public void setRotateLogFiles(List rotateLogFiles) {
		this.rotateLogFiles = rotateLogFiles;
	}

	public String getNeedDisplayTime() {
		return needDisplayTime;
	}

	public void setNeedDisplayTime(String needDisplayTime) {
		this.needDisplayTime = needDisplayTime;
	}

	public String getFileSizeForDisplay() {
		return fileSizeForDisplay;
	}

	public void setFileSizeForDisplay(String fileSizeForDisplay) {
		this.fileSizeForDisplay = fileSizeForDisplay;
	}

}

