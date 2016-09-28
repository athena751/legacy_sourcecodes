/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicLinkStatusListAction.java,v 3.2 2005/06/13 02:01:04 fengmh Exp
 */
package com.nec.nsgui.action.nic;

import java.util.Vector;

import javax.servlet.http.*;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nic.NicHandler;
import org.apache.struts.action.DynaActionForm;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.action.base.NSActionConst;

public class NicLinkStatusListAction extends Action {
    private static final String cvsid = "@(#) $Id: NicLinkStatusListAction.java,v 1.4 2005/11/01 09:01:40 dengyp Exp $";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String interfaceName = (String) (String) ((DynaActionForm) form)
        .get("interfaceName");
        String from = (String) (String) ((DynaActionForm) form)
        .get("nic_from4change");
        from = (from == null) ? "service" : from;
        request.setAttribute("nic_from4change", from);
        
        NSActionUtil.setSessionAttribute(request, "selectedInterface",
                        interfaceName);        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector statusList = new Vector();
        try{
            statusList = NicHandler.getLinkStatus(interfaceName, nodeNo);
        }catch(NSException ex){
            if((ex.getErrorCode().equals("0x10000008") || ex.getErrorCode().equals("0x10000009")) && from.equals("admin")){
                ex.setErrorCode("0x18A00030");
                NSActionUtil.removeSessionAttribute(request,NSActionConst.SESSION_SUCCESS_ALERT);                
            }          
            throw ex;                        
        }
        request.setAttribute("linkStatusList", statusList);
        return mapping.findForward("success");
    }
}