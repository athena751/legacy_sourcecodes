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

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.model.biz.base.CmdExecBase;

/**
 *For forward
 */
public class GfsForwardAction extends Action{
    private static final String cvsid = "@(#) $Id: GfsForwardAction.java,v 1.1 2005/11/04 01:25:07 zhangj Exp $";
    
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        CmdExecBase.checkClusterStatus();
        return mapping.findForward("gfsForward");
    }
}