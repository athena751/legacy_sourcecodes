/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.account;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.framework.SessionManager;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;

public class AccountTablistAction extends DispatchAction implements NSActionConst {
    private static final String cvsid =
        "@(#) $Id: AccountTablistAction.java,v 1.1 2004/12/14 04:41:55 k-nishi Exp";
    public ActionForward list(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        SessionManager sm = SessionManager.getInstance();
        Vector vec1 =
            (Vector) (sm.getActiveSessionsInfo(request).get(NSUSER_NSADMIN));
        if (vec1 != null && vec1.size() != 0) {
            SortTableModel tableModena = new ListSTModel(vec1);
            request.setAttribute(NSUSER_NSADMIN, tableModena);
        }
        Vector vec2 =
            (Vector) (sm.getActiveSessionsInfo(request).get(NSUSER_NSVIEW));
        if (vec2 != null && vec2.size() != 0) {
            SortTableModel tableModenv = new ListSTModel(vec2);
            request.setAttribute(NSUSER_NSVIEW, tableModenv);
        }
        return mapping.findForward("accountTablist");
    }
    
    public ActionForward redirect(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
            return mapping.findForward("redirect");
        }

}
