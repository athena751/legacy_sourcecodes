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

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.account.UserManager;

public class AccountTabnsadminAction
    extends DispatchAction
    implements NSActionConst {
    private static final String cvsid =
        "@(#) SetPasswdAction.java,v 1.1 2004/12/14 04:41:55 k-nishi Exp";
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        return mapping.findForward("display");
    }
    public ActionForward set(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        String user = NSUSER_NSADMIN;
        String passwd = BeanUtils.getProperty(form, "_nsadminpassword");
        UserManager.getInstance().setPasswd(user, passwd);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("set");
    }

}