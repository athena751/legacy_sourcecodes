/*
 *      Copyright (c) 2005 NEC Corporation
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

public class CollectionItemInfoBean2 extends CollectionItemInfoBeanBase {
    private static final String cvsid =
            "@(#) $Id: CollectionItemInfoBean2.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private Boolean status;

    public void fill(MonitorConfigBase mcBase,String targetID,String id,String item,String size,String period) throws Exception {
        super.fillProperties(id,item,size,period);
        if(mcBase.getClass().equals("MonitorConfig")){
            String tmpInterval = ((MonitorConfig)mcBase).getInterval(targetID,id);
            super.setInterval(super.sec2min(tmpInterval));
            status = new Boolean(((MonitorConfig)mcBase).getTargetStatus(targetID));
        }else{
            String tmpInterval = ((MonitorConfig2)mcBase).getInterval(targetID,id);
            super.setInterval(super.sec2min(tmpInterval));
            status = new Boolean(((MonitorConfig2)mcBase).getTargetStatus(targetID,id));
        }
    }

    /**
     * @return
     */
    public Boolean getStatus() {
        return status;
    }

}