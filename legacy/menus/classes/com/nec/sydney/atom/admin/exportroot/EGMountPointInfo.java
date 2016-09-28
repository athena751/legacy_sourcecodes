/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.atom.admin.exportroot;
public class EGMountPointInfo
{
    private static final String     cvsid = "@(#) $Id: EGMountPointInfo.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";

    //the subItems of mount point info
    private String  hexMountPoint;
    private String  fsType;
    private String  mountStatus;
    private boolean hasNFSExported;
    private boolean hasCIFSShare;
    private boolean hasAuth;
    private boolean hasSchedule;
    private boolean hasFtp;
    private boolean hasHttp;
    private String quotaStatus;
    private String filesetType;
    private String region;

    //constructor
    public EGMountPointInfo() {
        hexMountPoint = "";
        fsType = "";
        mountStatus = "";
        hasNFSExported = false;
        hasCIFSShare = false;
        hasAuth = false;
        hasSchedule = false;
        quotaStatus = "";
        filesetType = "";
        region = "";
    }   
    
    //the GET methods
    public String getHexMountPoint() {
        return hexMountPoint;
    }
    
    public String getFsType() {
        return fsType;
    }
    
    public String getMountStatus() {
        return mountStatus;
    }
    
    public boolean getHasNFS() {
        return hasNFSExported;
    }
    
    public boolean getHasCIFS() {
        return hasCIFSShare;
    }
    
    public boolean getHasAuth() {
        return hasAuth;
    }
    
    public boolean getHasSchedule() {
        return hasSchedule;
    }

    public boolean getHasFtp() {
        return hasFtp;
    }    

    public boolean getHasHttp() {
        return hasHttp;
    }    

    public String getQuotaStatus() {
        return quotaStatus;
    }

    public String getFilesetType() {
        return filesetType;
    }

    public String getRegion() {
        return region;
    }

    //the SET methods
    public void	setHexMountPoint(String hexMountPoint) {
        this.hexMountPoint = hexMountPoint;
    }
    
    public void	setFsType(String fsType) {
        this.fsType = fsType;
    }
    
    public void	setMountStatus(String mountStatus) {
        this.mountStatus = mountStatus;
    }
    
    public void	setHasNFS(boolean hasNFSExported) {
        this.hasNFSExported = hasNFSExported;
    }
    
    public void	setHasCIFS(boolean hasCIFSShare) {
        this.hasCIFSShare = hasCIFSShare;
    }
    
    public void	setHasAuth(boolean hasAuth) {
        this.hasAuth = hasAuth;
    }
    
    public void	setHasSchedule(boolean hasSchedule) {
        this.hasSchedule = hasSchedule;
    }

    public void setHasFtp(boolean hasFtp) {
        this.hasFtp = hasFtp;
    }    

    public void setHasHttp(boolean hasHttp) {
        this.hasHttp = hasHttp;
    }    

    public void	setQuotaStatus(String quotaStatus) {
        this.quotaStatus = quotaStatus;
    }
    
    public void	setFilesetType(String filesetType) {
        this.filesetType = filesetType;
    }
    
    public void	setRegion(String region) {
        this.region = region;
    }
}