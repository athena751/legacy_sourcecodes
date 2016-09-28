/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.ddr;


/*
 *
 */
public class DdrRVDetailBean extends DdrVolInfoBean {
    private static final String cvsid =
            "@(#) $Id: DdrRVDetailBean.java,v 1.1 2008/04/19 10:02:53 liuyq Exp $";
    
    private String syncState = "";
    private String copyControlState = "";
    private String progressRate = "";
    private String syncStartTime = "";

    /**
     * @return Returns the copyControlState.
     */
    public String getCopyControlState() {
        return copyControlState;
    }
    /**
     * @param copyControlState The copyControlState to set.
     */
    public void setCopyControlState(String copyControlState) {
        this.copyControlState = copyControlState;
    }
    /**
     * @return Returns the progressRate.
     */
    public String getProgressRate() {
        return progressRate;
    }
    /**
     * @param progressRate The progressRate to set.
     */
    public void setProgressRate(String progressRate) {
        this.progressRate = progressRate;
    }
    /**
     * @return Returns the syncStartTime.
     */
    public String getSyncStartTime() {
        return syncStartTime;
    }
    /**
     * @param syncStartTime The syncStartTime to set.
     */
    public void setSyncStartTime(String syncStartTime) {
        this.syncStartTime = syncStartTime;
    }
    /**
     * @return Returns the syncState.
     */
    public String getSyncState() {
        return syncState;
    }
    /**
     * @param syncState The syncState to set.
     */
    public void setSyncState(String syncState) {
        this.syncState = syncState;
    }

}