/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.replication;

/**
 *
 */
public class ReplicaInfoBean {
    public static final String cvsid =
        "@(#) $Id: ReplicaInfoBean.java,v 1.4 2008/05/28 03:25:32 liy Exp $";
    private String originalServer = "";
    private String filesetName = "";
    private String connected = "";
    private String syncRate = "";
    private String transInterface = "";
    private String replicationData = "all"; // all, onlysnap, curdata
    private String snapKeepLimit = "";
    private String repliMethod = "";
    private String volSyncInFileset = "";
    private String useSnapKeep = "off";
    private String mountPoint = "";
    private String hasShared = "";
    private String hasMounted = "";
    private String originalMP = "";
    private String onceConnected = "";
    private String replicationMode = "overwrite";
    private String volumeName = "";
    private String wpCode = "";
    
    private String asyncStatus="normal"; // normal, create, extend, replica (replica is a flag of creating replica volume)
    private String errCode="0x00000000"; // 0x00000000 when normal or error code
 

    /**
     * @return
     */
    public String getConnected() {
        return connected;
    }

    /**
     * @return
     */
    public String getFilesetName() {
        return filesetName;
    }

    /**
     * @return
     */
    public String getHasMounted() {
        return hasMounted;
    }

    /**
     * @return
     */
    public String getHasShared() {
        return hasShared;
    }

    /**
     * @return
     */
    public String getMountPoint() {
        return mountPoint;
    }

    /**
     * @return
     */
    public String getOnceConnected() {
        return onceConnected;
    }

    /**
     * @return
     */
    public String getOriginalMP() {
        return originalMP;
    }

    /**
     * @return
     */
    public String getOriginalServer() {
        return originalServer;
    }

    /**
     * @return
     */
    public String getReplicationData() {
        return replicationData;
    }

    /**
     * @return
     */
    public String getReplicationMode() {
        return replicationMode;
    }

    /**
     * @return
     */
    public String getSyncRate() {
        return syncRate;
    }

    /**
     * @return
     */
    public String getTransInterface() {
        return transInterface;
    }

    /**
     * @param string
     */
    public void setConnected(String string) {
        connected = string;
    }

    /**
     * @param string
     */
    public void setFilesetName(String string) {
        filesetName = string;
    }

    /**
     * @param string
     */
    public void setHasMounted(String string) {
        hasMounted = string;
    }

    /**
     * @param string
     */
    public void setHasShared(String string) {
        hasShared = string;
    }

    /**
     * @param string
     */
    public void setMountPoint(String string) {
        mountPoint = string;
    }

    /**
     * @param string
     */
    public void setOnceConnected(String string) {
        onceConnected = string;
    }

    /**
     * @param string
     */
    public void setOriginalMP(String string) {
        originalMP = string;
    }

    /**
     * @param string
     */
    public void setOriginalServer(String string) {
        originalServer = string;
    }

    /**
     * @param string
     */
    public void setReplicationData(String string) {
        replicationData = string;
    }

    /**
     * @param string
     */
    public void setReplicationMode(String string) {
        replicationMode = string;
    }

    /**
     * @param string
     */
    public void setSyncRate(String string) {
        syncRate = string;
    }

    /**
     * @param string
     */
    public void setTransInterface(String string) {
        transInterface = string;
    }

    /**
     * @return
     */
    public String getVolumeName() {
        return volumeName;
    }

    /**
     * @param string
     */
    public void setVolumeName(String string) {
        volumeName = string;
    }

    /**
     * @return
     */
    public String getWpCode() {
        return wpCode;
    }

    /**
     * @param string
     */
    public void setWpCode(String string) {
        wpCode = string;
    }

    /**
     * @return
     */
    public String getErrCode() {
        return errCode;
    }

    /**
     * @param string
     */
    public void setErrCode(String string) {
        errCode = string;
    }



    /**
     * @return
     */
    public String getAsyncStatus() {
        return asyncStatus;
    }

    /**
     * @param string
     */
    public void setAsyncStatus(String string) {
        asyncStatus = string;
    }

	public String getRepliMethod() {
		return repliMethod;
	}

	public void setRepliMethod(String repliMethod) {
		this.repliMethod = repliMethod;
	}

	public String getSnapKeepLimit() {
		return snapKeepLimit;
	}

	public void setSnapKeepLimit(String snapKeepLimit) {
		this.snapKeepLimit = snapKeepLimit;
	}

	public String getUseSnapKeep() {
		return useSnapKeep;
	}

	public void setUseSnapKeep(String useSnapKeep) {
		this.useSnapKeep = useSnapKeep;
	}

	public String getVolSyncInFileset() {
		return volSyncInFileset;
	}

	public void setVolSyncInFileset(String volSyncInFileset) {
		this.volSyncInFileset = volSyncInFileset;
	}

}
