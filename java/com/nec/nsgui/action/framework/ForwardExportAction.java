/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.framework;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.entity.framework.FrameworkConst;

public class ForwardExportAction extends Action implements FrameworkConst {
    private static final String cvsid = "@(#) $Id$";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        try {
            CmdExecBase.checkClusterStatus();
        } catch (NSException ne) {
            if (ne.getErrorCode().equals(ERRCODE_CLUSTER_NODE0_ERROR)
                    || ne.getErrorCode().equals(ERRCODE_CLUSTER_NODE1_ERROR)) {
                throw ne;
            }
        }
        return mapping.findForward("forwardexport");
    }
}