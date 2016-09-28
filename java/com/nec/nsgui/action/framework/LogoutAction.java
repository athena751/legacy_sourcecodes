/*
 *      Copyright (c) 2004-2008 NEC Corporation
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

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.syslog.SyslogCmdHandler;

public class LogoutAction extends Action {
    public static final String cvsid =
        "@(#) $Id: LogoutAction.java,v 1.7 2008/06/05 05:33:38 hetao Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        if(request !=null && request.getSession() != null && request.isRequestedSessionIdValid()){
            if(request.getSession().getAttribute(NSActionConst.SESSION_USERINFO) != null){
                SyslogCmdHandler.delTmpLogFile(request.getSession().getId()); 
            }
        }
        request.getSession().setAttribute(NSActionConst.SESSION_AUTHENTICATED, "-");
        request.getSession().removeAttribute(NSActionConst.SESSION_USERINFO);

        String href = request.getParameter("href");
        if(href != null && href != ""){
        	request.getSession().invalidate();
        }
        request.setAttribute("href", request.getParameter("href"));
        
        return mapping.findForward("logout");
    }
}
