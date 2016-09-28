/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.account;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.biz.framework.NSTimeout;
import com.nec.nsgui.action.framework.*;

public class AccountTimeoutSetAction extends Action {
    private static final String cvsid = "@(#) $Id: AccountTimeoutSetAction.java,v 1.4 2005/10/19 00:21:45 fengmh Exp $";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String nsadmin_timeout = (String) ((DynaActionForm) form)
                .get("nsadminTimeout");
        String nsview_timeout = (String) ((DynaActionForm) form)
                .get("nsviewTimeout");
        String reflectNow = (String) ((DynaActionForm) form).get("reflectNow");
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NSModelUtil.setValueByProperty(NSActionConst.PATH_OF_TIMEOUT_CONF,
                NSActionConst.NSADMIN_TIMEOUT, nsadmin_timeout, nodeNo);
        NSModelUtil.setValueByProperty(NSActionConst.PATH_OF_TIMEOUT_CONF,
                NSActionConst.NSVIEW_TIMEOUT, nsview_timeout, nodeNo);
        NSTimeout.getInstance().setNsadminTimeout(nsadmin_timeout);
        NSTimeout.getInstance().setNsviewTimeout(nsview_timeout);
        SessionManager.getInstance().changeSessionTimeout(nsadmin_timeout,
                NSActionConst.NSUSER_NSADMIN);
        if(reflectNow.equals("true")) {
            SessionManager.getInstance().changeSessionTimeout(nsview_timeout,
                    NSActionConst.NSUSER_NSVIEW);
        }
        if (NSActionUtil.isCluster(request)) {
            try {
                NSModelUtil.setValueByProperty(
                        NSActionConst.PATH_OF_TIMEOUT_CONF,
                        NSActionConst.NSADMIN_TIMEOUT, nsadmin_timeout,
                        1 - nodeNo);
                NSModelUtil.setValueByProperty(
                        NSActionConst.PATH_OF_TIMEOUT_CONF,
                        NSActionConst.NSVIEW_TIMEOUT, nsview_timeout,
                        1 - nodeNo);
            } catch (Exception ex) {
            }
        }
        NSActionUtil.setSessionAttribute(request,
                NSActionConst.SESSION_SUCCESS_ALERT, "true");
        return mapping.findForward("success");
    }
}