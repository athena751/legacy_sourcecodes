/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.nfs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import com.nec.nsgui.model.entity.nfs.DetailInfoBean;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nfs.NFSModel;

/**
 *
 */
public class NfsDetailAction extends DispatchAction {
    private static final String cvsid =
        "@(#) $Id: NfsDetailAction.java,v 1.2 2004/09/09 09:39:10 het Exp $";

    public ActionForward commit(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dynaForm = (DynaActionForm)form;
        String orgDir = (String)dynaForm.get("orgSelectedDir");
        String dir =  NSActionUtil.getExportGroupPath(request) + "/" + (String)dynaForm.get("selectedDir");
        dynaForm.set("selectedDir",dir);
        String clientOptions = ((DetailInfoBean)dynaForm.get("detailInfo")).getClientOptions();
        int group = NSActionUtil.getCurrentNodeNo(request);
        NFSModel.setExportClients(orgDir,dir,clientOptions,group);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("commitSuccess");
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
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        String directory = (String) dynaForm.get("selectedDir");
        if(((String)dynaForm.get("opType")).equals("add")){
            directory = "";
            dynaForm.set("selectedDir",directory);
        }
        String expgrp = NSActionUtil.getExportGroupPath(request);
        int group = NSActionUtil.getCurrentNodeNo(request);
        dynaForm.set(
            "detailInfo",
            NFSModel.getDetailInfo(expgrp, directory, group));
        dynaForm.set("orgSelectedDir", directory);
        return mapping.findForward("display");
    }
}
