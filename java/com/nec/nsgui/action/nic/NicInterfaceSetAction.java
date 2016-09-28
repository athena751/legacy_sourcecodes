/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicInterfaceSetAction.java,v 1.3 2005/10/24 04:51:16 dengyp Exp $
 */

package com.nec.nsgui.action.nic;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nic.NicHandler;
import com.nec.nsgui.model.entity.nic.NicInformationBean;

public class NicInterfaceSetAction extends Action {
    private static final String cvsid = "@(#) $Id: NicInterfaceSetAction.java,v 1.3 2005/10/24 04:51:16 dengyp Exp $";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicInformationBean interfaceInfo = (NicInformationBean) ((DynaActionForm) form)
                .get("interfaceSet");
        NSActionUtil
                .setSessionAttribute(request, "interfaceSet", interfaceInfo);
        NicHandler.setInterfaceStatus(interfaceInfo, nodeNo);
        NSActionUtil.setSessionAttribute(request,
                NSActionConst.SESSION_SUCCESS_ALERT, "true");
        String from = (String) NSActionUtil.getSessionAttribute(request,"nic_from4change");
        if (from == null || from.equals("service")){
            return mapping.findForward("success");
        }else if (from.equals("bond")) {
            return mapping.findForward("toBond");
        }else{
            return mapping.findForward("toVlan");
        }
    }
}