/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
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
import com.nec.nsgui.action.framework.SessionManager;

public class AccountNsviewOutAction extends Action {
    private static final String cvsid = "@(#) $Id: AccountNsviewOutAction.java,v 1.4 2005/10/19 00:21:45 fengmh Exp $";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String sessionId = (String) ((DynaActionForm) form)
        .get("sessionId");
        if(!sessionId.equals("")) {
            String[] sessionIds = sessionId.split(" ");
            SessionManager.getInstance().disconnect(sessionIds);
        }
        NSActionUtil.setSessionAttribute(request,
                NSActionConst.SESSION_SUCCESS_ALERT, "true");
        return mapping.findForward("success");
    }
}