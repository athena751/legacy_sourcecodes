/*
 *      Copyright (c) 2005 NEC Corporation
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

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nfs.NFSModel;

/**
 *Actions for direct edit page
 */
public class DirectEditAction extends DispatchAction implements NSActionConst {
    private static final String cvsid =
        "$Id: DirectEditAction.java,v 1.7 2005/06/22 07:59:22 wangzf Exp";
    /**
     * display the content of export group configure file 
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

		int group = NSActionUtil.getCurrentNodeNo(request);
        String content = NFSModel.getFileContent(group);
        ((DynaActionForm) form).set(
            "fileContent",
            NSActionUtil.perl2Page(content, BROWSER_ENCODE));
        return mapping.findForward("nfsDirectEdit");
    }

    /**
     * display the content of export group configure file 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward reload(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

		return display(mapping, form, request, response);
    }

	/**
     * modify the content of export group configure file
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward save(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

		int group = NSActionUtil.getCurrentNodeNo(request);
        String content = (String) ((DynaActionForm) form).get("fileContent");
        String perlContent = NSActionUtil.page2Perl(content, BROWSER_ENCODE, BROWSER_ENCODE);
        ((DynaActionForm) form).set("fileContent",NSActionUtil.reqStr2EncodeStr(content, BROWSER_ENCODE));
        NFSModel.saveFileContent(
            group,
            perlContent);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("nfsDirectEdit");
    }
}
