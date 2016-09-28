/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.statis;

import com.nec.nsgui.model.entity.statis.CollectionItemInfoBean;
import com.nec.nsgui.model.entity.statis.CollectionItemInfoBean2;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;

public class CollectionBeanFactory {
    private static final String cvsid ="@(#) $Id: CollectionBeanFactory.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    public static CollectionItemInfoBeanBase create(
        String flag,
        MonitorConfigBase mcBase,
        String targetID,
        String itemID,
        String item,
        String size,
        String period)
        throws Exception {
        if (flag.equals("sampling")) {
            CollectionItemInfoBean colBean = new CollectionItemInfoBean();
            colBean.fill(mcBase,targetID, itemID,item, size, period);
            return colBean;
        } else {
            CollectionItemInfoBean2 colBean = new CollectionItemInfoBean2();
            colBean.fill(mcBase,targetID,itemID,item, size, period);
            return colBean;
        }
    }
}