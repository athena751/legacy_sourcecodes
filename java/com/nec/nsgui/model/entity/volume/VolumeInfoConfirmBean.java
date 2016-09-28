/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.volume;

public class VolumeInfoConfirmBean extends VolumeInfoBean {
    private static final String cvsid =
        "@(#) $Id: VolumeInfoConfirmBean.java,v 1.4 2008/05/24 12:16:41 liuyq Exp $";    
    private boolean volumeNameExist;
    private boolean MPNameExist ;
    private String MPErrorCode;
    private boolean usePairedLd4Syncfs;
    
    public VolumeInfoConfirmBean() {
        super();
        this.volumeNameExist = false;
        this.MPNameExist = false;
        this.MPErrorCode = "0";
        this.usePairedLd4Syncfs = false;
    }
    
    public VolumeInfoConfirmBean(VolumeInfoBean volumeInfo) {
        setCapacity(volumeInfo.getCapacity());
        setFsType(volumeInfo.getFsType());
        setLun(volumeInfo.getLun());
        setLunDisplay(volumeInfo.getLunDisplay());
        setLdPath(volumeInfo.getLdPath());
        setMachineType(volumeInfo.getMachineType());
        setMountPoint(volumeInfo.getMountPoint());
        setNoatime(volumeInfo.getNoatime());
        setAname(volumeInfo.getAname());
        setAid(volumeInfo.getAid());
        setPoolName(volumeInfo.getPoolName());
        setPoolNo(volumeInfo.getPoolNo());
        setRaidType(volumeInfo.getRaidType());
        setQuota(volumeInfo.getQuota());
        setDmapi(volumeInfo.getDmapi());
        setReplication(volumeInfo.getReplication());
        setReplicType(volumeInfo.getReplicType());
        setSnapshot(volumeInfo.getSnapshot());
        setStorage(volumeInfo.getStorage());
        setVolumeName(volumeInfo.getVolumeName());
        setWwnn(volumeInfo.getWwnn());
        setMountStatus(volumeInfo.getMountStatus());
        setAccessMode(volumeInfo.getAccessMode());
        
        this.volumeNameExist = false;
        this.MPNameExist = false;
        this.MPErrorCode = "0";
        this.usePairedLd4Syncfs = false;
    }
    
    public boolean getVolumeNameExist() {
        return this.volumeNameExist;
    }
    
    public void setVolumeNameExist(boolean volumeNameExist) {
        this.volumeNameExist = volumeNameExist;
    }
    
    public boolean getMPNameExist() {
        return this.MPNameExist;
    }
    
    public void setMPNameExist(boolean MPNameExist) {
        this.MPNameExist = MPNameExist;
    }
    
    public String getMPErrorCode() {
        return this.MPErrorCode;
    }
    
    public void setMPErrorCode(String errorCode) {
        this.MPErrorCode = errorCode;
    }

    public boolean isUsePairedLd4Syncfs() {
        return usePairedLd4Syncfs;
    }

    public void setUsePairedLd4Syncfs(boolean usePairedLd4Syncfs) {
        this.usePairedLd4Syncfs = usePairedLd4Syncfs;
    }
}