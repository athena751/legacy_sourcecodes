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

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.serverprotect.ServerProtectHandler;
public class ServerProtectScanShareAddAction extends DispatchAction 
        implements ServerProtectActionConst{
    private static final String cvsid = "@(#) $Id: ServerProtectScanShareAddAction.java,v 1.2 2007/03/30 06:47:12 wanghui Exp $";
    
public ActionForward entry(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String domainName = (String) NSActionUtil.getSessionAttribute(request,
                SESSION_SERVERPROTECT_DOMAINNAME);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        String[] shares = ServerProtectHandler.getScanShare4Add(nodeNumber,
                domainName, computerName);
        if(null == shares || shares.length ==0) {//no valid share
            String alertMessage = getResources(request).getMessage(
                    request.getLocale(),
                    "serverprotect.alert.noshare4add");
            NSActionUtil.setSessionAttribute(request,
                    NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                    alertMessage);
            return mapping.findForward("noshare4add");
        }
        String[] shareNames = new String[shares.length / 2];
        String[] shareNamesLabel = new String[shares.length / 2];
        int j=0;
        for (int i = 0; i + 1 < shares.length; i += 2) {
            shareNames[j] = shares[i] + ',' + shares[i + 1];
            shareNamesLabel[j] = shares[i];
            j++;
        }        
        NSActionUtil.setSessionAttribute(request,
                "serverprotect_shareNames", shareNames);
        NSActionUtil.setSessionAttribute(request,
                "serverprotect_shareNamesLabel", shareNamesLabel);
        return mapping.findForward("scanshareadd");        
    }
    
    public ActionForward load(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        String daemonState = ServerProtectHandler.getDaemonState(nodeNumber,
                computerName);        
        request.setAttribute("daemonState", daemonState);
        
        return mapping.findForward("scanshareaddtop");        
    }
    
    public ActionForward set(ActionMapping mapping, ActionForm form, 
            HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        String computerName = (String) NSActionUtil.getSessionAttribute(
                request, SESSION_SERVERPROTECT_COMPUTERNAME);
        DynaActionForm scanShareChangeForm = (DynaActionForm) form;        
        String selectedShare = (String)scanShareChangeForm.get(
                CONST_SCANSHARE_FORM_SELECTEDSHARE);        
        String readCheck = (String)scanShareChangeForm.get(
                CONST_SCANSHARE_CHANGE_FORM_READCHECK);
        String writeCheck = (String)scanShareChangeForm.get(
                CONST_SCANSHARE_CHANGE_FORM_WRITECHECK);
        
        String shareInfo = Integer.toString(nodeNumber) + "\n" 
                             + computerName + "\n" + selectedShare + "\n"
                             + readCheck + "," + writeCheck;               
        
        ServerProtectHandler.addScanShare(nodeNumber, shareInfo);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("setsuccess");
    }
}
