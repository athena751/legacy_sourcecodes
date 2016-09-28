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
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;

public class LVMCreateShowBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMCreateShowBean.java,v 1.2303 2005/11/18 00:57:08 liuyq Exp $";

    private String lvtype; 
    private boolean is1Node = false;

    public LVMCreateShowBean() {
    }
    
    public void beanProcess() throws Exception {
        lvtype = request.getParameter("lvtype");
        is1Node =NSActionUtil.isOneNodeSirius(request);
        if(NSActionUtil.isNashead(request)){
            LicenseInfo license = LicenseInfo.getInstance();
            String hasGfsLicense =
                                license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0 ? "true" : "false";
            request.setAttribute("hasGfsLicense", hasGfsLicense);
        }
        
    }

    public String getTarget() {
        return target;
    }
    
    public String getLvtype() {
        return lvtype;
    }

    public boolean getIs1Node(){
        return is1Node;    
    }
}