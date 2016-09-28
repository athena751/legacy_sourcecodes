/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.volume.VolumeHandler;

public class VolumeClearTmpFileAction extends Action implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id$";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        String volName = request.getParameter("volName");
        VolumeHandler.delAsyncFile(volName, NSActionUtil.getCurrentNodeNo(request));
        String fowardUrl = (String)NSActionUtil.getSessionAttribute(request, SESSION_FROM);
        if(fowardUrl==null || fowardUrl.equals("")) {
            fowardUrl="volume";
        }
        request.getSession().setAttribute(
            NSActionConst.SESSION_SUCCESS_ALERT,
            "true");
        return mapping.findForward(fowardUrl);
    }
}
