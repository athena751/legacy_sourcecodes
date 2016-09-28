/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.nic;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.nic.NicHandler;
import com.nec.nsgui.model.entity.nic.NicInformationBean;
import com.nec.nsgui.action.nic.NicActionConst;

public class NicIPAliasTopAction extends DispatchAction implements
        NSActionConst {
    private static final String cvsid = "@(#) $Id: NicIPAliasTopAction.java,v 1.4 2007/08/30 09:24:21 fengmh Exp $";

    public ActionForward display(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector nicList = new Vector();
        NSActionUtil.setSessionAttribute(request, "alias_over_total", "no");
        try {
            nicList = NicHandler.getNicForAlias(nodeNo);
        } catch (NSException ex) {
            if (ex.getErrorCode().equals(NicActionConst.IPALIAS_SET_OVER_TOTAL)) {
                NSActionUtil.setSessionAttribute(request, "alias_over_total",
                        "yes");
            } else {
                throw ex;
            }
        }

        NicInformationBean interfaceInfo = (NicInformationBean) ((DynaActionForm) form)
                .get("interfaceSet");
        interfaceInfo.setNicName("");
        interfaceInfo.setAlias("");
        interfaceInfo.setIpAddress("");
        interfaceInfo.setGateway("");
        NSActionUtil.setSessionAttribute(request, "nodeNo", nodeNo);
        NSActionUtil.setSessionAttribute(request, "nicList", nicList);
        request.setAttribute("aliasID_need_change", "yes");
        
        return mapping.findForward("display");
    }

    public ActionForward set(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicInformationBean interfaceInfo = (NicInformationBean) ((DynaActionForm) form)
                .get("interfaceSet");
        String nicName = interfaceInfo.getNicName().split("#")[0];
        String ipAddress = interfaceInfo.getIpAddress();
        String gateway = interfaceInfo.getGateway();
        String alias = nodeNo + interfaceInfo.getAlias();
        String msg = "";
        try {
            NicHandler.setIPAlias(nodeNo, nicName, ipAddress, gateway, alias);
        } catch (NSException ex) {
            if (ex.getErrorCode().equals(NicActionConst.IPALIAS_SET_OVER_TOTAL)) {
                MessageResources msgResource = (MessageResources) getResources(request);
                msg = msgResource.getMessage(request.getLocale(),
                        NicActionConst.IPALIAS_SET_OVER_TOTAL_ALERT);
                NSActionUtil.setSessionAttribute(request,
                        NSActionUtil.SESSION_OPERATION_RESULT_MESSAGE, msg);
            } else {
                throw ex;
            }
        }
        if (msg.equals("")) {
            NSActionUtil.setSessionAttribute(request,
                    NSActionConst.SESSION_SUCCESS_ALERT, "true");
        }
        return mapping.findForward("set");
    }
}