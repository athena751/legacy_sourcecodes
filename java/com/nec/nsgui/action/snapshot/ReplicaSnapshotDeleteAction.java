/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snapshot;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.snapshot.ReplicaSnapshotHandler;

public class ReplicaSnapshotDeleteAction extends Action implements SnapshotActionConst {
    private static final String cvsid =
        "@(#) $Id: ReplicaSnapshotDeleteAction.java,v 1.1 2008/05/28 02:13:37 lil Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {

        // get selected snapshot names
        DynaActionForm dynaForm = (DynaActionForm) form;
        String delSnapNames = (String) dynaForm.get("delSnapshotNames");
        
        // get hex mount point
        String hexMpStr = 
            (String) NSActionUtil.getSessionAttribute(request, SESSION_SNAPSHOT_HEX_MOUNTPOINT);

        // get current node no
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);

        // delete
        ReplicaSnapshotHandler.deleteSnapshot(hexMpStr, delSnapNames, nodeNo);

        // success alert
        NSActionUtil.setSuccess(request);
        
        // forward
        return mapping.findForward("success");
    }
}
