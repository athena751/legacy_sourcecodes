/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

import com.nec.nsgui.action.base.NSActionUtil;

/**
 *
 */
public class CsvDownloadInfoBean {
    private static final String cvsid =
               "@(#) $Id: CsvDownloadInfoBean.java,v 1.2 2007/03/07 06:30:54 yangxj Exp $";
    String originalWatchItemID = "";
    String periodType = "";
    String defaultPeriod = "";
    String customStartTime = "";
    String customEndTime = "";
    String host = "";
    String defaultResource = "";
    String collectionItemId = "";
    String interval = "";
    String isSurvey = "false";
    //add exprgroup for ServerProtect
    String exprgroup = "";
    String cpName = "";
    String domainName = "";
    /**
     * @return
     */
    public String getCustomEndTime() {
        return customEndTime;
    }

    /**
     * @return
     */
    public String getCustomStartTime() {
        return customStartTime;
    }

    /**
     * @return
     */
    public String getDefaultPeriod() {
        return defaultPeriod;
    }

    /**
     * @return
     */
    public String getHost() {
        return host;
    }

    /**
     * @return
     */
    public String getOriginalWatchItemID() {
        return originalWatchItemID;
    }

    /**
     * @return
     */
    public String getPeriodType() {
        return periodType;
    }

    /**
     * @param string
     */
    public void setCustomEndTime(String string) {
        customEndTime = string;
    }

    /**
     * @param string
     */
    public void setCustomStartTime(String string) {
        customStartTime = string;
    }

    /**
     * @param string
     */
    public void setDefaultPeriod(String string) {
        defaultPeriod = string;
    }

    /**
     * @param string
     */
    public void setHost(String string) {
        host = string;
    }

    /**
     * @param string
     */
    public void setOriginalWatchItemID(String string) {
        originalWatchItemID = string;
    }

    /**
     * @param string
     */
    public void setPeriodType(String string) {
        periodType = string;
    }

    /**
     * @return
     */
    public String getDefaultResource() {
        return defaultResource;
    }

    /**
     * @param string
     */
    public void setDefaultResource(String string) {
        defaultResource = string;
    }

    public String getHeartbeatWinName()
        throws Exception {
        String heartbeatWinName;
        if (defaultResource.equals("")) {
            heartbeatWinName =
                NSActionUtil.ascii2hStr(
                    host
                        + originalWatchItemID)
                    + "heartbeat";
        } else {
            heartbeatWinName =
                NSActionUtil.ascii2hStr(
                    host
                        + originalWatchItemID
                        + defaultResource)
                    + "heartbeat";
        }
        
        return heartbeatWinName;
    }

    /**
     * @return
     */
    public String getCollectionItemId() {
        return collectionItemId;
    }

    /**
     * @param string
     */
    public void setCollectionItemId(String string) {
        collectionItemId = string;
    }

    /**
     * @return
     */
    public String getInterval() {
        return interval;
    }

    /**
     * @param string
     */
    public void setInterval(String string) {
        interval = string;
    }

    /**
     * @return
     */
    public String getIsSurvey() {
        return isSurvey;
    }

    /**
     * @param string
     */
    public void setIsSurvey(String string) {
        isSurvey = string;
    }

	public String getCpName() {
		return cpName;
	}

	public void setCpName(String cpName) {
		this.cpName = cpName;
	}

	public String getDomainName() {
		return domainName;
	}

	public void setDomainName(String domainName) {
		this.domainName = domainName;
	}

	public String getExprgroup() {
		return exprgroup;
	}

	public void setExprgroup(String exprgroup) {
		this.exprgroup = exprgroup;
	}

}
