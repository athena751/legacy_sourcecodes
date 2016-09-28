/*
 *      Copyright (c) 2005 NEC Corporation
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
public class MountPointBean {
    public static final String cvsid =
            "@(#) $Id: MountPointBean.java,v 1.1 2005/09/15 05:56:19 liyb Exp $";
   
    private String mountPoint = "";
    private String mountPointLast = "";  //mountpoint without exportGroup string
    private String volumeName = "";
    private String fsType = ""; 

    /**
     * @return
     */
    public String getFsType() {
        return fsType;
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
    public String getVolumeName() {
        return volumeName;
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
    public void setMountPoint(String string) {
        mountPoint = string;
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
    public String getMountPointLast() {
        return mountPointLast;
    }



    /**
     * @param string
     */
    public void setMountPointLast(String string) {
        mountPointLast = string;
    }

}
