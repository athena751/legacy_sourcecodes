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

public class AccountTabnsviewAction
    extends DispatchAction
    implements NSActionConst {
    private static final String cvsid =
        "@(#) SetPasswdAction.java,v 1.1 2004/12/14 04:41:55 k-nishi Exp";
    private static final String CHECK_CONNECTION = "checkconnection";
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        String user = NSUSER_NSVIEW;
        if (UserManager.getInstance().getNSUserByUserName(NSUSER_NSVIEW)
            == null) {
            BeanUtils.setProperty(form, CHECK_CONNECTION, "false");
        } else
            BeanUtils.setProperty(form, CHECK_CONNECTION, "true");
        return mapping.findForward("display");
    }
    public ActionForward set(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        String user = NSUSER_NSVIEW;
        String passwd = BeanUtils.getProperty(form, "_nsviewpassword");
        String checkconnection = BeanUtils.getProperty(form, CHECK_CONNECTION);
        boolean existnsview =
            (UserManager.getInstance().getNSUserByUserName(NSUSER_NSVIEW)
                != null)
                ? true
                : false;
        if (checkconnection.equals("on")) {
            if (existnsview) {
                UserManager.getInstance().setPasswd(user, passwd);
            } else {
                UserManager.getInstance().addnsview(user, passwd);
            }
        } else {
            if (existnsview) {
                UserManager.getInstance().delete(user);
            }
        }
        NSActionUtil.setSuccess(request);
        return mapping.findForward("set");
    }
}