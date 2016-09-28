/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicLinkStatusSetAction.java,v 1.4 2005/11/01 09:01:40 dengyp Exp $
 */

package com.nec.nsgui.action.nic;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nic.NicHandler;
import com.nec.nsgui.model.entity.nic.NicDetailLinkBean;
import com.nec.nsgui.model.biz.base.NSException;

public class NicLinkStatusSetAction extends Action {
    private static final String cvsid = "@(#) $Id: NicLinkStatusSetAction.java,v 1.4 2005/11/01 09:01:40 dengyp Exp $";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicDetailLinkBean[] statusSet = (NicDetailLinkBean[]) ((DynaActionForm) form)
                .get("linkStatusSet");
        Vector listToSet = new Vector();
        for (int i = 0; i < statusSet.length; i++) {
            if (!statusSet[i].getNicName().equals("")) {
                listToSet.add(statusSet[i]);
            }
        }
        DynaActionForm linkStatusForm = (DynaActionForm)NSActionUtil.getSessionAttribute(request,"interfaceNameForm");
        String from = (String)linkStatusForm.get("nic_from4change");
        from = (from == null) ? "service" : from;
        try{
            NicHandler.setLinkStatus(listToSet, nodeNo);
        }catch(NSException ex){
            if((ex.getErrorCode().equals("0x10000008") || ex.getErrorCode().equals("0x10000009")) && from.equals("admin")){
                ex.setErrorCode("0x18A00030");
            }           
            throw ex;              
        }
        NSActionUtil.setSessionAttribute(request,
                NSActionConst.SESSION_SUCCESS_ALERT, "true");
        return mapping.findForward("success");
    }
}