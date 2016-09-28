/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.CollectionItemDef;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.TargetDef;
import com.nec.nsgui.model.biz.statis.WatchItemDef;

/**
 *  
 */
public class GraphAssistantBase implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: GraphAssistantBase.java,v 1.3 2005/10/19 08:22:49 zhangj Exp $";    
    protected HttpServletRequest _request;

    protected String watchItemId;

    protected MonitorConfigBase mc;

    protected WatchItemDef wid;

    protected String targetId;

    public void init(HttpServletRequest request, String flag) {
        watchItemId = (String) NSActionUtil.getSessionAttribute(request,
                SESSION_WATCHITEM_ID);
        mc = (MonitorConfig2) NSActionUtil.getSessionAttribute(request,
                SESSION_MC_4SURVEY);

        wid = mc.getWatchItemDef(watchItemId);
        targetId = (String) NSActionUtil.getSessionAttribute(request,
                SESSION_TARGET_ID);
        _request = request;
    }

    public void init(HttpServletRequest request) {
        watchItemId = (String) NSActionUtil.getSessionAttribute(request,
                SESSION_WATCHITEM_ID);

        mc = (MonitorConfig) NSActionUtil.getSessionAttribute(request,
                SESSION_MC);

        wid = mc.getWatchItemDef(watchItemId);
        targetId = (String) NSActionUtil.getSessionAttribute(request,
                SESSION_TARGET_ID);
        _request = request;
    }

    public String getClusterTag() {
        TargetDef td = mc.getTargetDef(targetId);
        WatchItemDef wid = mc.getWatchItemDef(watchItemId);
        String collectionID = wid.getCollectionItem().trim();
        if (td.getType().equals(TargetDef.NASIPSAN)) {
            if (collectionID.equals(CollectionItemDef.iSCSI_Session)
                    || collectionID.equals(CollectionItemDef.iSCSI_Auth)) {
                return "false";
            } else {
                return "true";
            }
        } else if (td.getType().equals(TargetDef.CLUSTER)) {
            return "true";
        } else {
            return "false";
        }
    }

    public String getNickName(String targetId) {
        return mc.getTargetDef(targetId).getNickName();
    }

    public List getTargetList() {
        List targetList = new ArrayList();
        TargetDef td = mc.getTargetDef(targetId);
        if (getClusterTag().equals("true")) {
            targetList.addAll(td.getNodes());
        } else {
            targetList.add(targetId);
        }
        return targetList;
    }
}