/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.nfs;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nfs.NFSModel;

/**
 *
 */
public class NfsDetailInfoAction extends Action {
    private static final String cvsid =
        "@(#) $Id: NfsDetailInfoAction.java,v 1.1 2005/06/22 08:01:06 wangzf Exp $";

    /**
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        String directory = (String) dynaForm.get("selectedDir");
        int group = NSActionUtil.getCurrentNodeNo(request);
        Vector clients = NFSModel.getClientInfo(directory, group);
        request.setAttribute("clients", clients);
        return mapping.findForward("display");
    }

}
