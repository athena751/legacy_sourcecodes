/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.lvm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;

public class LVMManageShowBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMManageShowBean.java,v 1.2303 2005/11/18 01:01:53 liuyq Exp $";

    private boolean isCluster;
    private String lvname;
    private String disks;
    private String size;
    private String lunStorage;
    private boolean is1Node = false;
    
    public LVMManageShowBean() {
    }

    public void beanProcess() throws Exception {
        isCluster = (super.request.getParameter("iscluster").equals("true"))?true:false;
        String value = (String)(super.request.getParameter("otherRadio"));
        String[] infos = value.split(",");
        lvname = infos[0];
        size = infos[2];
        lunStorage = NSActionUtil.reqStr2EncodeStr(infos[3], NSActionUtil.ENCODING_EUC_JP);
        disks = infos[4];
        is1Node =NSActionUtil.isOneNodeSirius(request);
    }

    public boolean getIsCluster() {
        return isCluster;
    }

    public String getLvname() {
        return lvname;
    }

    public String getDisks() {
        return disks;
    }

    public String getSize() {
        return size;
    }
    
    public String getLunStorage() {
        return lunStorage;
    }
    

    public boolean is1Node(){
        return is1Node;
    }
}