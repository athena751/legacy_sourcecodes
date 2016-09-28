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

import com.nec.nsgui.model.biz.framework.NSTimeout;

public class AccountTimeoutGetAction extends Action {
    private static final String cvsid = "@(#) $Id: AccountTimeoutGetAction.java,v 1.4 2005/10/19 00:21:45 fengmh Exp $";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        NSTimeout.getInstance().fresh();
        ((DynaActionForm) form).set("nsadminTimeout", NSTimeout.getInstance()
                .getNsadminTimeout());
        ((DynaActionForm) form).set("nsviewTimeout", NSTimeout.getInstance()
                .getNsviewTimeout());
        ((DynaActionForm) form).set("reflectNow", "");
        return mapping.findForward("success");
    }
}