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
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.SnapshotGraphDef;
import com.nec.nsgui.model.entity.statis.DeviceInfoBean;

/**
 *Actions for community
 */
public class SnapshotAction
    extends DispatchAction
    implements StatisActionConst {
    private static final String cvsid =
        "@(#) $Id: SnapshotAction.java,v 1.1 2005/10/18 16:24:27 het Exp $";

    public ActionForward init(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dForm = (DynaActionForm) form;
        NSActionUtil.setSessionAttribute(
            request,
            SESSION_WATCHITEM_ID,
            dForm.get("watchItem"));
        String user =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_USERINFO);
        MonitorConfig mc = new MonitorConfig();
        mc.loadDefs();
        NSActionUtil.setSessionAttribute(request, SESSION_MC, mc);
        SnapshotGraphDef sgd = mc.loadSnapshotGraphDef(user, false);
        NSActionUtil.setSessionAttribute(request, SESSION_SGD, sgd);
        String targetID = request.getParameter("target");
        targetID = MonitorConfig.stripTargetID(targetID);
        NSActionUtil.setSessionAttribute(request, SESSION_TARGET_ID, targetID);
        SnapshotAssistant sa = new SnapshotAssistant();
        sa.init(request);

        request.setAttribute("watchItemDesc", sa.getWatchItemKey());
        request.setAttribute("defaultGraphType", sa.getSSnapshotType());

        return mapping.findForward("enterSnapshot");
    }

    public ActionForward displayList(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dForm = (DynaActionForm) form;
        String graphType = (String) dForm.get("graphType");
        String[] sortKey = (String[]) dForm.get("sortKey");
        String[] orderFlag = (String[]) dForm.get("orderFlag");
        SnapshotGraphDef sgd =
            (SnapshotGraphDef) NSActionUtil.getSessionAttribute(
                request,
                SESSION_SGD);

        String displayOSInfo = (String) dForm.get("displayOSInfo");
        if (displayOSInfo == null || displayOSInfo.equals("")) {
            displayOSInfo =
                (String) request.getSession().getAttribute(
                    SESSION_DISPLAY_OS_INFO);
            if (displayOSInfo == null) {
                displayOSInfo = "false";
            }
        }
        request.getSession().setAttribute(
            SESSION_DISPLAY_OS_INFO,
            displayOSInfo);
        dForm.set("displayOSInfo", displayOSInfo);

        sgd.setType(graphType);
        NSActionUtil.setSessionAttribute(request, SESSION_SGD, sgd);
        SnapshotAssistant sa = new SnapshotAssistant();
        sa.init(request);
        request.setAttribute("isCluster", sa.getClusterTag());
        request.setAttribute(
            "graphInfoList",
            sa.getGraphInfoList(graphType, sortKey, orderFlag));
        if (graphType.equals("Pie")) {
            return mapping.findForward("displayPieList");
        } else {
            return mapping.findForward("displayBarList");
        }
    }

    public ActionForward displayDetail(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String subItem = request.getParameter("subItem");
        int pos = subItem.indexOf(':');
        String targetID = subItem.substring(0, pos);
        String deviceID = subItem.substring(pos + 1);

        SnapshotAssistant sa = new SnapshotAssistant();
        sa.init(request);
        HashMap deviceResult = sa.loadOneDevice(targetID, deviceID);
        String returnValue = (String) deviceResult.get("exitValue");
        request.setAttribute("returnValue", returnValue);
        if (returnValue.equals("0")) {
            ArrayList tempList = (ArrayList) deviceResult.get("deviceList");
            DeviceInfoBean deviceInfo = (DeviceInfoBean) tempList.get(0);
            request.setAttribute("deviceInfo", deviceInfo);
        }

        request.setAttribute("watchItemId", sa.getWatchItemId());
        request.setAttribute("watchItemDesc", sa.getWatchItemKey());
        request.setAttribute("nickName", sa.getNickName(targetID));
        request.setAttribute("sWidth", sa.getSFullWidth());
        request.setAttribute("sHeight", sa.getSHeight());
        return mapping.findForward("displayDetail");
    }

}