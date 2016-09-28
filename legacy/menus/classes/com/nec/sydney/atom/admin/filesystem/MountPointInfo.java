/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.filesystem;
public class MountPointInfo
{
    private static final String     cvsid = "@(#) $Id: MountPointInfo.java,v 1.2301 2004/11/12 02:23:31 wangzf Exp $";

    //the subItems of mountPoint info

    private String mountPointForDisplay;
    private String hexMountPoint;
    private String deviceName;
    private String status;
    private String fsType;
    private String repliStatus;
    private String hasPSID;
    private String mode;
    private String quota;
    private String update;
    private String dmAPI;
    
    //constructor
    public MountPointInfo() {
        mountPointForDisplay    = "";
        hexMountPoint           = "";
        deviceName              = "";
        status                  = "";
        fsType                  = "";
        repliStatus             = "";
        hasPSID                 = "";
    }

    // the GET methods
    public String getMountPointForDisplay() {
        return mountPointForDisplay;
    }

    public String getHexMountPoint() {
        return hexMountPoint;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public String getStatus() {
        return status;
    }

    public String getFSType() {
        return fsType;
    }

    public String getRepliStatus() {
        return repliStatus;
    }

    public String getHasPSID() {
        return hasPSID;
    }
    
    public String getMode() {
        return mode;
    }
    
    public String getQuota() {
        return quota;
    }
    
    public String getUpdate() {
        return update;
    }

    public String getDmAPI() {
        return dmAPI;
    }
        
    //the SET methods
    public void setMountPointForDisplay(String paramMountPointForDisplay) {
        mountPointForDisplay = paramMountPointForDisplay;
    }

    public void setHexMountPoint(String paramHexMountPoint) {
        hexMountPoint = paramHexMountPoint;
    }

    public void setDeviceName(String paramDeviceName) {
        deviceName = paramDeviceName;
    }

    public void setStatus(String paramStatus) {
        status = paramStatus;
    }

    public void setFSType(String paramFSType) {
        fsType = paramFSType;
    }

    public void setRepliStatus(String paramRepliStatus) {
        repliStatus = paramRepliStatus;
    }

    public void setHasPSID(String paramHasPSID) {
        hasPSID = paramHasPSID;
    }
    
    public void setMode(String paramMode) {
        mode = paramMode;
    }
    
    public void setQuota(String paramQuota) {
        quota = paramQuota;
    }
    
    public void setUpdate(String paramUpdate) {
        update = paramUpdate;
    }

    public void setDmAPI(String paramDmAPI) {
        dmAPI = paramDmAPI;
    }

}
