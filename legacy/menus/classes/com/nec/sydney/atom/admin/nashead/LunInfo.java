/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */ 
 
package    com.nec.sydney.atom.admin.nashead;


import com.nec.sydney.net.soap.*;
import java.util.*;


public class LunInfo extends SoapResponse {
    private static final String     cvsid = "@(#) $Id: LunInfo.java,v 1.3 2008/04/19 15:09:03 jiangfx Exp $";
    String lun = "";
    String devicePath = "";
    String connectStatus = "";
    String lvm = "";
    String pairStatus = "";
    
    public String getPairStatus() {
        return pairStatus;
    }

    public void setPairStatus(String pairStatus) {
        this.pairStatus = pairStatus;
    }

    public LunInfo() {}
    
    public String getLun() {
        return this.lun;
    }

    public String getDevicePath() {
        return this.devicePath;
    }

    public String getConnectStatus() {
        return this.connectStatus;
    }

    public String getLvm() {
        return this.lvm;
    }
    
    public void setLun(String lun) {
        this.lun = lun;
    } 

    public void setDevicePath(String devicePath) {
        this.devicePath = devicePath;
    }

    public void setConnectStatus(String connectStatus) {
        this.connectStatus = connectStatus;
    }

    public void setLvm(String lvm) {
        this.lvm = lvm;
    } 
}
