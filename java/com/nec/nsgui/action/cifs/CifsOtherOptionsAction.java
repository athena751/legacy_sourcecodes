/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.entity.cifs.CifsOtherOptionsBean;

/**
 * Actions for direct edit page
 */
public class CifsOtherOptionsAction extends DispatchAction implements CifsActionConst {
    private static final String cvsid = "@(#) $Id: CifsOtherOptionsAction.java,v 1.1 2006/11/06 06:06:12 fengmh Exp $";

    /**
     * display the share list
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward displayOtherOptions(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        String[] directHosting = CifsCmdHandler.getDirectHosting(nodeNo, domainName, computerName);
        CifsOtherOptionsBean otherOptions = new CifsOtherOptionsBean();
        otherOptions.setDirectHosting(directHosting[0]);
        DynaActionForm dynaForm = (DynaActionForm) form;
        dynaForm.set("otherOptions", otherOptions);
        if(directHosting[1].equals("0")) {
            request.setAttribute(REQUEST_DISABLE_DIRECTHOSTING, "0");
        } else if(directHosting[1].equals("1")) {
            request.setAttribute(REQUEST_DISABLE_DIRECTHOSTING, "1");
        }
        return mapping.findForward("loadTop");
    }
    
    /**
     * display the share list
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward setOtherOptions(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        DynaActionForm dynaForm = (DynaActionForm) form;
        CifsOtherOptionsBean otherOptions = (CifsOtherOptionsBean) dynaForm.get("otherOptions");
        String result = CifsCmdHandler.setDirectHosting(nodeNo, domainName, computerName, otherOptions);
        if(result.equals("0")) {
            request.setAttribute(REQUEST_DISABLE_DIRECTHOSTING, "0");
        } else if (result.equals("1")) {
            request.setAttribute(REQUEST_DISABLE_DIRECTHOSTING, "1");
        } else {
            NSActionUtil.setSuccess(request);
            return mapping.findForward("set_directHostingSuccess");
        }
        return mapping.findForward("loadTop");
    }
   
}
