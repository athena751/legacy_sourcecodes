/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.krb5;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;

public class Krb5TwoAccountAction extends Action {
    //private static final String cvsid = "@(#) $Id: Krb5TwoAccountAction.java,v 1.1 2006/11/06 06:23:21 liy Exp $";
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) 
            throws Exception {

        if (NSActionUtil.isNsview(request)) {
            return mapping.findForward("krb5ListNsview");
        } else {
            return mapping.findForward("krb5ListNsadmin");
        }
    }
}
