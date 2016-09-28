/*
 *      Copyright (c) 2005-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.filesystem;

public class FilesystemInfoBean{

    private static final String cvsid = "@(#) $Id: FilesystemInfoBean.java,v 1.3 2006/02/23 01:00:50 liuyq Exp $";

	private String lvPath = "";  
	private String mountPoint = ""; 
	private String lvSize = "";
	private String fsType = "sxfs";
	private String accessMode = "rw";
	private Boolean quota = new Boolean("false");
	private Boolean updateAccessTime = new Boolean("false");
	private String replicationType = "original";
	private Boolean repli = new Boolean("false");
	private String mountStatus = "";
	private String hasSetSnapshot = "";
	private Boolean norecovery = new Boolean("false");
	private Boolean dmapi = new Boolean("false");
	private Boolean format = new Boolean("false");
	private String snapshotArea = "100";
	private String journalType = "standard";
	private String rankNo = "";
	private String capacity = "";
    private String useGfs = "false";
    private String wpPeriod="--";//see description in VolumeInfoBean 
	
	public String getLvPath(){
		return lvPath;
	}	
	public String getMountPoint(){
		return mountPoint;
	}
	public String getLvSize(){
		return lvSize;
	}
	public String getFsType(){
		return fsType;
	}
	public String getAccessMode(){
		return accessMode;
	}
	public Boolean getQuota(){
		return quota;
	}
	public Boolean getUpdateAccessTime(){
		return updateAccessTime;
	}
	public String getReplicationType(){
		return replicationType;
	}
	public String getMountStatus(){
		return mountStatus;
	}
	public String getHasSetSnapshot(){
		return hasSetSnapshot;
	}
	public Boolean getNorecovery(){
		return norecovery;
	}	
	public Boolean getDmapi(){
		return dmapi;
	}	
	public Boolean getFormat(){
		return format;
	}
	public String getSnapshotArea(){
		return snapshotArea;
	}
	public String getJournalType(){
		return journalType;
	}	
	public String getRankNo(){
		return rankNo;
	}
	public String getCapacity(){
		return capacity;
	}
	public Boolean getRepli() {
		return repli;
	}
	public void setLvPath(String string){
		lvPath = string;
	}	
	public void setMountPoint(String string){
		mountPoint = string;
	}
	public void setLvSize(String string){
		lvSize = string;
	}
	public void setFsType(String string){
		fsType = string;
	}
	public void setAccessMode(String string){
		accessMode = string;
	}
	public void setQuota(Boolean string){
		quota = string;
	}
	public void setUpdateAccessTime(Boolean string){
		updateAccessTime = string;
	}
	public void setReplicationType(String string){
		replicationType = string;
	}
	public void setMountStatus(String string){
		mountStatus = string;
	}
	public void setHasSetSnapshot(String string){
		hasSetSnapshot = string;
	}
	public void setNorecovery(Boolean string){
		norecovery = string;
	}
	public void setDmapi(Boolean string){
		dmapi = string;
	}
	public void setFormat(Boolean string){
		format = string;
	}
	public void setSnapshotArea(String string){
		snapshotArea = string;
	}
	public void setJournalType(String string){
		journalType = string;
	}
	public void setRankNo(String string){
		rankNo = string;
	}
	public void setCapacity(String string){
			capacity = string;
	}	
	public void setRepli(Boolean string) {
		repli = string;
	}

    /**
     * @return
     */
    public String getUseGfs() {
        return useGfs;
    }

    /**
     * @param string
     */
    public void setUseGfs(String string) {
        useGfs = string;
    }
    public String getWpPeriod() {
        return wpPeriod;
    }
    public void setWpPeriod(String wpPeriod) {
        this.wpPeriod = wpPeriod;
    }

}