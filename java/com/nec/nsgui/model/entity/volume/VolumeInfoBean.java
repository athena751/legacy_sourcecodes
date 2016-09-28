/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.volume;

import java.util.Iterator;
import java.util.TreeMap;

import com.nec.nsgui.action.base.NSActionUtil;

public class VolumeInfoBean {
    private static final String cvsid =
        "@(#) $Id: VolumeInfoBean.java,v 1.24 2008/10/15 02:19:26 jiangfx Exp $";    
    private String machineType; // "NASHEAD" or "NV"

    private String volumeName;
    private String mountPoint;
    private String fsType="sxfs";

    private String capacity;
    private String extendSize;
    private String capacityUnit = "GB";
    
    // only in NV serials machine , the following three properties must be set. add for 128TB
    private String aname;
    private String aid;
    private String raidType;
    private String poolName;
    private String poolNo;
    private String poolNameAndNo;
    private String bltime = "24";
    private String manageCapOfLD;
    
    // only in nashead machine , the following two properties must be set.
    private String wwnn = ""; // such as : "200000004c51781a,200000004c51781a"
    private String lun = ""; //  such as : "10,16"   not hex!!
    private String lunDisplay; //such as : "10(0Ah)"
    private String storage = "--"; //optional  such as : "storage1,storage2"
    private String storage4Extend = "";
    private String ldPath = "";    //logical path for lun
    
    private Boolean quota = new Boolean("false");
    private String snapshot = "100"; // 10 <= snapshot <=100
    private Boolean noatime = new Boolean("false");
    private Boolean replication = new Boolean("false");
    private String journal = "standard"; //"standard" or "expand"
    private String replicType; // "" or "original" or "replic"
    
    private String replication4Show = "--"; // 4 type: -- notset original replic  
    
    private String mountStatus;  // "mount" or "umount"
    private String accessMode;  // "rw" or "ro"
    private Boolean norecovery = new Boolean("false");
    private Boolean dmapi = new Boolean("false");
    
    private String status;
    private String useRate;
    private String useGfs = "false";
    private String striping = "false";
    private String useCode="0x00000000";
    private String fsSize="--";
    
    /***description for wpPeriod***
     *  value       list                    create            modify
        --          can not get             do nothing        do nothing
        -1          inactive                                  active->inactive
        1~10950     active, is wp period    set to active     inactive->active 
     *
     *****/
    private String wpPeriod="--";
    private String asyncStatus;
    private String errCode;
    
    private String statusDetailInfo=""; 
    public String getStatusDetailInfo(){
        return statusDetailInfo;
    }
    public void setStatusDetailInfo(String s){
        statusDetailInfo = s;
    }
    
    public String getStatus() {
        return status;
    }
    public void setStatus(String string) {
        status = string;
    }
    public VolumeInfoBean() {
        super();
    }
    
    public VolumeInfoBean(boolean isNashead , String [] infos) {
    /** 
     ** NV:
     *     volumeName mountPoint poolNameAndNo raidType capacity fsType quota replication updateAccessTime  
     *     snapshot accessmode  isMounted norecovery dmapi useRate useGfs aid aname useCode fsSize wpCode
     ** NASHEAD:
     *     volumeName mountPoint storage lun     capacity    fsType  quota   replication updateAccessTime    snapshot  
     *     accessMode mountstatus norecovery dmapi useRate useGfs useCode fsSize wpCode
    **/
        this.volumeName = infos[0];
        this.mountPoint = infos[1];
        if(isNashead){
            this.machineType = "NASHEAD";
            this.storage = infos[2];
            this.lun = infos[3];
        }else{
            this.machineType = "NV";
            this.poolNameAndNo = infos[2];
            this.raidType      = infos[3];
        }

        this.capacity = infos[4];
        this.fsType = infos[5];
        
        if(infos[6].equals("off")){
            this.quota = new Boolean(false);
        }else{
            this.quota = new Boolean(true);
        }
        
        this.replication = new Boolean(true);
        if(infos[7].equals("--")){
            this.replication = new Boolean(false);
            this.replicType = "";
            this.replication4Show="--";
        }else if(infos[7].equals("notset")){
            this.replicType = "";
            this.replication4Show="notset";
        }else{
            this.replicType = infos[7];
            if(this.replicType.equals("original")){
                this.replication4Show = "original";
            }else{
                this.replication4Show = "replic";
            }
        }
        
        if(!infos[8].equals("off")){//logic different
            this.noatime = new Boolean(false);
        }else{
            this.noatime = new Boolean(true);
        }
           
        this.snapshot    = infos[9];
        this.accessMode  = infos[10];
        this.mountStatus = infos[11];
        
        if(infos[12].equals("off")){
            this.norecovery = new Boolean(false);
        }else{
            this.norecovery = new Boolean(true);
        }
        
        if(infos[13].equals("off")){
            this.dmapi = new Boolean(false);
        }else{
            this.dmapi = new Boolean(true);
        }
        
        this.useRate = infos[14];
        this.useGfs = infos[15];
        
        int newIndex = 16;
        if (!isNashead) {
            this.aid    = infos[16];
            this.aname  = infos[17];
            this.asyncStatus  = infos[18];
            this.errCode  = infos[19];
            newIndex = 20;
        }
        
        this.useCode = infos[newIndex];
        this.fsSize = infos[newIndex + 1];
        this.wpPeriod = infos[newIndex + 2];
        
        if (isNashead) {
            sortStorageAndLun();    
        }
    }
   
    
    public void sortStorageAndLun() {
        String[] storageArr, lunArr;
        if ((storage == null) || (lun == null)) {
            return;
        }
        
        storageArr = storage.split(",");
        lunArr = lun.split(",");
        if (storageArr.length != lunArr.length) {
            return;
        }
        
        TreeMap map = new TreeMap(); // use TreeMap to sort
        for (int i = 0; i < storageArr.length; i++) {
            String tmp = storageArr[i] + "," + lunArr[i];        
            String tmp1 = tmp;
            
            if (!lunArr[i].equals("--")) {
                String hex =
                    Integer.toHexString(Integer.parseInt(lunArr[i]));
                if (hex.length() < 2) {
                    hex = "0" + hex; // lun is between 0 ~ 255
                }
                tmp1 = storageArr[i] + "," + hex;
                //when the length of Storages are not same ,there is no problem
                // because there is "," .
            }
            map.put(tmp1, tmp);
        }
        
        Iterator itr = map.keySet().iterator();
        itr.next(); // skip the first one

        String[] infos = ((String) map.get(map.firstKey())).split(",");
        StringBuffer info1 = new StringBuffer(infos[0]);
        StringBuffer info2 = new StringBuffer(infos[1]);
        while (itr.hasNext()) {
            infos = ((String) map.get(itr.next())).split(",");
            info1.append(",").append(infos[0]); // get storages String
            info2.append(",").append(infos[1]); // get luns String
        }
        
        storage = info1.toString();
        lun = info2.toString();
    }

    /**
     * @return
     */
    public String getCapacity() {
        return capacity;
    }

    /**
     * @return
     */
    public String getFsType() {
        return fsType;
    }

    /**
     * @return
     */
    public String getLun() {
        return lun;
    }
    
    public String getLunDisplay() {
        return lunDisplay;
    }

    /**
     * @return
     */
    public String getMachineType() {
        return machineType;
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
    public Boolean getNoatime() {
        return noatime;
    }

    /**
     * @return
     */
    public Boolean getQuota() {
        return quota;
    }

    /**
     * @return
     */
    public Boolean getReplication() {
        return replication;
    }

    /**
     * @return
     */
    public String getReplicType() {
        return replicType;
    }

    /**
     * @return
     */
    public String getSnapshot() {
        return snapshot;
    }

    /**
     * @return
     */
    public String getStorage() {
        return storage;
    }

    /**
     * @return
     */
    public String getVolumeName() {
        return volumeName;
    }

    /**
     * @return
     */
    public String getWwnn() {
        return wwnn;
    }

    /**
     * @param string
     */
    public void setCapacity(String string) {
        capacity = string;
    }

    /**
     * @param string
     */
    public void setFsType(String string) {
        fsType = string;
    }

    /**
     * @param string
     */
    public void setLun(String string) {
        lun = string;
    }
    
    public void setLunDisplay(String string) {
        lunDisplay = string;
    }

    /**
     * @param string
     */
    public void setMachineType(String string) {
        machineType = string;
    }

    /**
     * @param string
     */
    public void setMountPoint(String string) {
        mountPoint = string;
    }

    /**
     * @param boolean1
     */
    public void setNoatime(Boolean boolean1) {
        noatime = boolean1;
    }


    /**
     * @param boolean1
     */
    public void setQuota(Boolean boolean1) {
        quota = boolean1;
    }


    /**
     * @param boolean1
     */
    public void setReplication(Boolean boolean1) {
        replication = boolean1;
    }

    /**
     * @param string
     */
    public void setReplicType(String string) {
        replicType = string;
    }

    /**
     * @param string
     */
    public void setSnapshot(String string) {
        snapshot = string;
    }

    /**
     * @param string
     */
    public void setStorage(String string) {
        storage = string;
    }

    /**
     * @param string
     */
    public void setVolumeName(String string) {
        volumeName = string;
    }

    /**
     * @param string
     */
    public void setWwnn(String string) {
        wwnn = string;
    }

    /**
     * @return
     */
    public String getMountStatus() {
        return mountStatus;
    }

    /**
     * @param string
     */
    public void setMountStatus(String string) {
        mountStatus = string;
    }

    /**
     * @return
     */
    public String getAccessMode() {
        return accessMode;
    }

    /**
     * @param string
     */
    public void setAccessMode(String string) {
        accessMode = string;
    }

   

    /**
     * @return
     */
    public String getJournal() {
        return journal;
    }

    /**
     * @param string
     */
    public void setJournal(String string) {
        journal = string;
    }

    /**
     * @return
     */
    public Boolean getNorecovery() {
        return norecovery;
    }

    /**
     * @param boolean1
     */
    public void setNorecovery(Boolean boolean1) {
        norecovery = boolean1;
    }

    /**
     * @return
     */
    public Boolean getDmapi() {
        return dmapi;
    }

    /**
     * @param boolean1
     */
    public void setDmapi(Boolean boolean1) {
        dmapi = boolean1;
    }

    /**
     * @return
     */
    public String getLunStorage() throws Exception {
        if(this.getLun().trim().equals("--") 
           || this.getStorage().trim().equals("--")){
            return "--";
        }
        
        String jpSlash = " / ";
        String[] storages = this.getStorage().split(",");
        String[] luns = this.getLun().split(",");
        StringBuffer sb =
            new StringBuffer(NSActionUtil.getHexString(4, luns[0]))
                .append(jpSlash).append(storages[0]);
        for (int i = 1; i < luns.length; i++) {
            sb  .append("<BR>")
                .append(NSActionUtil.getHexString(4, luns[i]))
                .append(jpSlash).append(storages[i]);
        }
        return sb.toString();
    }

    /**
     * @return
     */
    public String getReplication4Show() {
        return replication4Show;
    }

    /**
     * @return
     */
    public void setReplication4Show(String string) {
        replication4Show = string;
    }    

    /**
     * @return
     */
    public String getUseRate() {
        return useRate;
    }

    /**
     * @param string
     */
    public void setUseRate(String string) {
        useRate = string;
    }

    /**
     * @return
     */
    public String getAid() {
        return aid;
    }

    /**
     * @return
     */
    public String getPoolNameAndNo() {
        return poolNameAndNo;
    }

    /**
     * @return
     */
    public String getRaidType() {
        return raidType;
    }

    /**
     * @param string
     */
    public void setAid(String string) {
        aid = string;
    }

    /**
     * @param string
     */
    public void setPoolNameAndNo(String string) {
        poolNameAndNo = string;
    }

    /**
     * @param string
     */
    public void setRaidType(String string) {
        raidType = string;
    }

    /**
     * @return
     */
    public String getAname() {
        return aname;
    }

    /**
     * @param string
     */
    public void setAname(String string) {
        aname = string;
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
    /**
     * @return
     */
    public String getPoolName() {
        return poolName;
    }

    /**
     * @return
     */
    public String getPoolNo() {
        return poolNo;
    }

    /**
     * @param string
     */
    public void setPoolName(String string) {
        poolName = string;
    }

    /**
     * @param string
     */
    public void setPoolNo(String string) {
        poolNo = string;
    }

    /**
     * @return
     */
    public String getExtendSize() {
        return extendSize;
    }

    /**
     * @param string
     */
    public void setExtendSize(String string) {
        extendSize = string;
    }

    /**
     * @return
     */
    public String getCapacityUnit() {
        return capacityUnit;
    }

    /**
     * @param string
     */
    public void setCapacityUnit(String string) {
        capacityUnit = string;
    }
    
    /**
     * @return
     */
    public String getStorage4Extend() {
        return storage4Extend;
    }

    /**
     * @param string
     */
    public void setStorage4Extend(String string) {
        storage4Extend = string;
    }
        

    // only in NV serials machine , the following three properties must be set.
    private String pdgNo="";
    private String rankNo="";
    /**
     * @return
     */
    public String getPdgNo() {
        return pdgNo;
    }
        /**
     * @return
     */
    public String getRankNo() {
        return rankNo;
    }
        /**
     * @param string
     */
    public void setPdgNo(String string) {
        pdgNo = string;
    }
        /**
     * @param string
     */
    public void setRankNo(String string) {
        rankNo = string;
    }
    /**
     * @return
     */
    public String getPdgRank(){
        if(this.getPdgNo().trim().equals("--")
           || this.getRankNo().trim().equals("--")){
            return "--";
        }
        
        String[] pdgs = this.getPdgNo().split(",");
        String[] ranks = this.getRankNo().split(",");
        StringBuffer sb = new StringBuffer(pdgs[0] + " - " + ranks[0]);
        for(int i=1; i<pdgs.length;i++){
            sb.append("<br>");
            sb.append(pdgs[i]).append(" - ").append(ranks[i]);
        }
        return sb.toString();
    }
    /**
     * @return
     */
    public String getStriping() {
        return striping;
    }

    /**
     * @param string
     */
    public void setStriping(String string) {
        striping = string;
    }
    /**
     * @return
     */
    public String getUseCode() {
        return useCode;
    }

    /**
     * @param string
     */
    public void setUseCode(String string) {
        useCode = string;
    }

    /**
     * @return
     */
    public String getFsSize() {
        return fsSize;
    }

    /**
     * @param string
     */
    public void setFsSize(String string) {
        fsSize = string;
    }

    public String getWpPeriod() {
        return wpPeriod;
    }
    public void setWpPeriod(String wpPeriod) {
        this.wpPeriod = wpPeriod;
    }
    /**
     * @return
     */
    public String getAsyncStatus() {
        return asyncStatus;
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
    public void setAsyncStatus(String string) {
        asyncStatus = string;
    }

    /**
     * @param string
     */
    public void setErrCode(String string) {
        errCode = string;
    }
    public String getBltime() {
        return bltime;
    }
    public void setBltime(String bltime) {
        this.bltime = bltime;
    }
    public String getLdPath() {
        return ldPath;
    }
    public void setLdPath(String ldPath) {
        this.ldPath = ldPath;
    }
	public String getManageCapOfLD() {
		return manageCapOfLD;
	}
	public void setManageCapOfLD(String manageCapOfLD) {
		this.manageCapOfLD = manageCapOfLD;
	}

}
