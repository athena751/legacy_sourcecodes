/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.gfs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.gfs.GfsCmdHandler;

/**
 *For System
 */
public class GfsAction4Nsview extends DispatchAction implements GfsActionConst{
    private static final String cvsid = "@(#) $Id: GfsAction4Nsview.java,v 1.2 2005/11/22 02:23:39 zhangj Exp $";
    public ActionForward display(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        String myNodeContent = NSActionUtil.perl2Page(GfsCmdHandler.getGfsFile(nodeNo), NSActionConst.BROWSER_ENCODE);
        NSActionUtil.setSessionAttribute( request,"myNodeContent",myNodeContent);
        return mapping.findForward("displayView");
    }
}
