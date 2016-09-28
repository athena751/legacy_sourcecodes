/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */ 
 
package    com.nec.sydney.atom.admin.nashead;


import com.nec.sydney.net.soap.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.framework.*;
import java.util.*;
import java.io.*;


public class GatewayInfo extends SoapResponse {
    private static final String     cvsid = "@(#) $Id: GatewayInfo.java,v 1.2 2004/03/15 08:46:21 caoyh Exp";
    private static final String LUN_OFFLINE = "-";
    private static final String DISP_LUN_OFFLINE = "------";
    
    String lun = "";
    String storageName = "";
    String state = "";       
    
    public String getLun() throws Exception {
        if (this.lun == null || this.lun.equals("")
                || this.lun.equals(LUN_OFFLINE)) {
            return DISP_LUN_OFFLINE; 
        } else {
            StringBuffer sb = new StringBuffer(this.lun);

            sb.append("(");
            sb.append(NSUtil.getHexString(4, this.lun));
            sb.append(")");
            return sb.toString();
        }
    }

    public String getStorageName() {
        return this.storageName;
    }

    public String getState() {
        return this.state;
    }
    
    public void setLun(String lun) {
        this.lun = lun;
    }

    public void setStorageName(String storageName) {
        this.storageName = storageName;
    }

    public void setState(String state) {
        this.state = state;
    }
       
}
