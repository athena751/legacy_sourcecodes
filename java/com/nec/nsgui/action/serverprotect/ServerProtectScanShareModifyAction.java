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
public class ServerProtectScanShareModifyAction extends DispatchAction 
        implements ServerProtectActionConst{
    private static final String cvsid = "@(#) $Id: ServerProtectScanShareModifyAction.java,v 1.2 2007/03/30 06:49:51 wanghui Exp $";
    
    public ActionForward load(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        String daemonState = ServerProtectHandler.getDaemonState(nodeNumber,
                computerName);        
        request.setAttribute("daemonState", daemonState);
        
        return mapping.findForward("scansharemodifytop");
    
    }
    
    public ActionForward set(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        DynaActionForm scanShareChangeForm = (DynaActionForm) form;        
        String shareName = (String)scanShareChangeForm.get(
                CONST_SCANSHARE_FORM_SELECTEDSHARE); 
        String readCheck = (String)scanShareChangeForm.get(
                CONST_SCANSHARE_CHANGE_FORM_READCHECK);
        String writeCheck = (String)scanShareChangeForm.get(
                CONST_SCANSHARE_CHANGE_FORM_WRITECHECK);                 
        
        ServerProtectHandler.modifyScanShare(nodeNumber, 
                computerName, shareName, readCheck, writeCheck);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("setsuccess");
    
    }
}
