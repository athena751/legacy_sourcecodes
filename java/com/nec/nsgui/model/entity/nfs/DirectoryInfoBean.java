/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.nfs;

public class DirectoryInfoBean extends com.nec.nsgui.model.entity.base.DirectoryInfoBean{
    private static final String cvsid =
        "@(#) $Id: DirectoryInfoBean.java,v 1.3 2004/12/30 08:32:31 het Exp $";

    private String displayedPath;
    private String wholePath;
    private String displaySelectedPath; // wholePath - rootDirectory
    private String dateString;
    private String timeString;
    private String dirType; // "file" or "directory"
    private String fsType;
    private String isSubMount;
    private String hasDomain;
    private String mountStatus;

    public DirectoryInfoBean() {
        displayedPath = "";
        wholePath = "";
        displaySelectedPath = "";
        dateString = "";
        timeString = "";
        dirType = "";
        fsType = "";
        isSubMount = "";
        hasDomain = "";
	mountStatus = "";
    }

    public String getDisplayedPath() {
        return this.displayedPath;
    }

    public void setDisplayedPath(String displayedPath) {
        this.displayedPath = displayedPath;
    }

    public String getWholePath() {
        return this.wholePath;
    }

    public void setWholePath(String wholePath) {
        this.wholePath = wholePath;
    }

    public String getDisplaySelectedPath() {
        return this.displaySelectedPath;
    }

    public void setDisplaySelectedPath(String displaySelectedPath) {
        this.displaySelectedPath = displaySelectedPath;
    }

    public String getDateString() {
        return this.dateString;
    }

    public void setDateString(String dateString) {
        this.dateString = dateString;
    }

    public String getTimeString() {
        return this.timeString;
    }

    public void setTimeString(String timeString) {
        this.timeString = timeString;
    }

    public String getDirType() {
        return this.dirType;
    }

    public void setDirType(String dirType) {
        this.dirType = dirType;
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
    public String getHasDomain() {
        return hasDomain;
    }

    /**
     * @return
     */
    public String getIsSubMount() {
        return isSubMount;
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
    public void setHasDomain(String string) {
        hasDomain = string;
    }

    /**
     * @param string
     */
    public void setIsSubMount(String string) {
        isSubMount = string;
    }

    public String getMountStatus() {
        return this.mountStatus;
    }
    
    public void setMountStatus(String mountStatus) {
        this.mountStatus = mountStatus;
    }
}