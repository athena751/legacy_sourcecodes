/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.serverprotect;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.serverprotect.ServerProtectHandler;

public class ServerProtectScanShareAction extends DispatchAction 
        implements ServerProtectActionConst{
    private static final String cvsid = "@(#) $Id: ServerProtectScanShareAction.java,v 1.1 2007/03/23 09:44:03 wanghui Exp $";
    
    public ActionForward load(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        
        //if have not set server protect, forward to "not set page"
        if (ServerProtectHandler.haveConfigFile(nodeNumber, computerName, false)
                .equals(CONST_SERVER_PROTECT_NO)){
            return mapping.findForward("noconfigfile");
        }
        
        request.setAttribute(REQUEST_SCAN_SHARE_LIST, 
                ServerProtectHandler.getScanShareList(nodeNumber, computerName, false));
        return mapping.findForward("scansharetop");
    }
    
    public ActionForward delete(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        DynaActionForm scanShareForm = (DynaActionForm) form;
        String shareName = (String)scanShareForm.get(CONST_SCANSHARE_FORM_SELECTEDSHARE);
        ServerProtectHandler.deleteScanShare(nodeNumber, computerName, shareName);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("setsuccess");
    
    }


}
