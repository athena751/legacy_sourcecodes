/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ndmpv4;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ndmpv4.NdmpHandler;



public class NdmpdManageAction extends DispatchAction implements NdmpActionConst {
    private static final String cvsid = "@(#) $Id: NdmpdManageAction.java,v 1.3 2006/12/26 02:59:20 wanghui Exp $";

    public ActionForward getStatus(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int nodeNum = NSActionUtil.getCurrentNodeNo(request);
        String status = NdmpHandler.getStatus(nodeNum);
        NSActionUtil.setSessionAttribute(request, "ndmpdStatus", status);
        return mapping.findForward("ndmpdStatus");
    }
    public ActionForward changeStatus(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int nodeNum = NSActionUtil.getCurrentNodeNo(request);      
        String version = NdmpHandler.getRunningVersion(nodeNum);        
        DynaActionForm dynaForm = (DynaActionForm) form;
        String chgStatus = (String)dynaForm.get("ndmpdManage");
        String needToCheckSession = (String)dynaForm.get("needToCheckSession");
        if (needToCheckSession.equalsIgnoreCase("true") &&
                !version.equals("2") && !chgStatus.equalsIgnoreCase("start")) {
            String sessionPath = NdmpHandler.getSessionPath(nodeNum);
            String needToConfirm = NdmpHandler.haveSessionInfo(nodeNum, sessionPath);
            if (needToConfirm.equalsIgnoreCase("true")) {                
                request.setAttribute("needToConfirm", "true");
                return mapping.findForward("ndmpdStatus");
            }       
        }
               
        String ret = NdmpHandler.changeStatus(chgStatus,nodeNum);
        NSActionUtil.setSessionAttribute(request,NDMP_SERVER_EXEC_RET,ret);
        if(ret.equals("SCRIPT_EXEC_SUCCESS")){
            NSActionUtil.setSuccess(request);
        }        
        return mapping.findForward("setSuccess");
    }
}
