/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.nfs;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.RpqLicense;
import com.nec.nsgui.model.biz.nfs.NFSModel;
import com.nec.nsgui.model.entity.nfs.NFSConstant;
/**
 *
 */
public class NfsListAction extends DispatchAction {
    public static final String cvsid = "@(#) $Id: NfsListAction.java,v 1.2 2009/04/23 02:06:24 yangxj Exp $";

    public ActionForward display(ActionMapping mapping,
                 ActionForm form,
                 HttpServletRequest request,
                 HttpServletResponse response)
    throws Exception {
        List entryList = NFSModel.getEntryList(NSActionUtil.getExportGroupPath(request), NSActionUtil.getCurrentNodeNo(request));    
        request.setAttribute("entryList", entryList);
        // 0: rpq on
        // 1: rpq off
        int rpqLicense = RpqLicense.getLicense(NFSConstant.RPQ_NO_UNSTABLEWRITE,NSActionUtil.getCurrentNodeNo(request));
        NSActionUtil.setSessionAttribute(request,NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY,Integer.toString(rpqLicense));
        return mapping.findForward("display");
    }

    public ActionForward delete(ActionMapping mapping,
                 ActionForm form,
                 HttpServletRequest request,
                 HttpServletResponse response)
    throws Exception {
        DynaActionForm thisForm = (DynaActionForm)form;
        String selectedDir = (String)thisForm.get("selectedDir");
        NFSModel.deleteEntry(selectedDir, NSActionUtil.getCurrentNodeNo(request)); 
        NSActionUtil.setSuccess(request);     
        return mapping.findForward("delSuccess");
    }

    
}