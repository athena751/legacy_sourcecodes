/*
 *      Copyright (c) 2008 NEC Corporation
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

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nfs.NFSModel;
import com.nec.nsgui.model.entity.nfs.LogInfoBean;
import com.nec.nsgui.model.entity.nfs.NFSConstant;

/**
 *Actions for direct edit page
 */
public class NfsLogAction
    extends DispatchAction
    implements NSActionConst, NFSConstant {
    private static final String cvsid =
        "@(#) $Id: NfsLogAction.java,v 1.3 2008/09/23 09:38:53 penghe Exp $";
    /**
     *  
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        Vector logInfos =
            NFSModel.getLogFileInfo(NSActionUtil.getCurrentNodeNo(request));
        request.setAttribute(
            "failedGetLogInfo",
            new Boolean(((String) logInfos.get(0)).equals("failure")));
        ((DynaActionForm) form).set("accessLogInfo", logInfos.get(1));
        return mapping.findForward("display");
    }
    /**
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward set(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        LogInfoBean accesslogInfo =
            (LogInfoBean) ((DynaActionForm) form).get("accessLogInfo");
        NFSModel.saveOptionsToFile(
            accesslogInfo,
            NSActionUtil.getCurrentNodeNo(request));
        NSActionUtil.setSuccess(request);
        return mapping.findForward("display");
    }
}
