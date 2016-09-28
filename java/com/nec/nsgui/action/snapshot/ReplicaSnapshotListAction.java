/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snapshot;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.biz.snapshot.ReplicaSnapshotHandler;
import com.nec.nsgui.model.entity.snapshot.SnapshotInfoBean;

public class ReplicaSnapshotListAction extends Action implements SnapshotActionConst {
    private static final String cvsid =
        "@(#) $Id: ReplicaSnapshotListAction.java,v 1.1 2008/05/28 02:13:37 lil Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {

        // get mp
        String hexMpStr = (String) NSActionUtil.getSessionAttribute(
                    request, SESSION_SNAPSHOT_HEX_MOUNTPOINT);

        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        List snapshotInfoList = ReplicaSnapshotHandler.getSnapshotInfoList(hexMpStr, nodeNo);

        // set form
        DynaActionForm dynaForm = (DynaActionForm) form;
        dynaForm.set("mp", NSModelUtil.hStr2Str(hexMpStr));
        
        if (snapshotInfoList.size() > 0) {
            // if delete fail, set checkbox checked or unchecked
            String oprRes = (String) request.getParameter("result");
            if ("fail".equals(oprRes)) {
                String delSnapNames = (String) dynaForm.get("delSnapshotNames");
                String[] delSnapNameArrs = delSnapNames.split(",");
                for (int i = 0; i < snapshotInfoList.size(); i++) {
                    SnapshotInfoBean snapBean = (SnapshotInfoBean) snapshotInfoList.get(i);
                    String snapName = snapBean.getName();
                    String snapStatus = snapBean.getStatus();
                    if (!"active".equalsIgnoreCase(snapStatus)) {
                        continue;
                    }
                    for (String delSnapName:delSnapNameArrs) {
                        if (delSnapName.equals(snapName)) {
                            snapBean.setChecked(true);
                        }
                    }
                }
            }
            
            // session
            request.setAttribute("replicaSnapshotInfoList", snapshotInfoList);
        }
        
        // forward
        if (NSActionUtil.isNsview(request)) {
            return mapping.findForward("showList4nsview");
        } else {
            return mapping.findForward("showList");
        }
    }
}
