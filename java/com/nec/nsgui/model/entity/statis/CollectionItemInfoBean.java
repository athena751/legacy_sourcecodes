/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.statis;

import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.action.statis.CollectionConst;

public class CollectionItemInfoBean extends CollectionItemInfoBeanBase{
    private static final String cvsid =
            "@(#) $Id: CollectionItemInfoBean.java,v 1.2 2007/03/07 06:28:46 yangxj Exp $";
    private String flag = "";
    public void fill(
        MonitorConfigBase mcBase,
        String targetID,
        String id,
        String item,
        String size,
        String period) throws Exception {
            super.fillProperties(id,item,size,period);
            if(mcBase instanceof MonitorConfig){
                String tmpInterval = ((MonitorConfig)mcBase).getInterval(targetID,id);
                super.setInterval(super.sec2min(tmpInterval));
                if(id.equals(CollectionConst.COLITEMID_ANTI_VIRUS_SCAN)){
                    //check license
                    int group = ClusterUtil.getInstance().getMyNodeNo();
                    LicenseInfo license = LicenseInfo.getInstance();
                    if ((license.checkAvailable(group,CollectionConst.SERVERPROTECT_LICENSE)) == 0){
                        //no license
                        flag = "disableRadio";
                    }
                }
            }else{
                String tmpInterval = ((MonitorConfig2)mcBase).getInterval(targetID,id);
                super.setInterval(super.sec2min(tmpInterval));
            }
    }
	public String getFlag() {
		return flag;
	}
    
}
    