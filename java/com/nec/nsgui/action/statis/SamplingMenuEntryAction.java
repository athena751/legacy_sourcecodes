/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.Action;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.*;

public class SamplingMenuEntryAction extends Action {
    public static final String cvsid 
            = "@(#) $Id: SamplingMenuEntryAction.java,v 1.1 2005/10/18 16:24:27 het Exp $";    
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String targetID =
            MonitorConfig.stripTargetID(request.getParameter("target"));
        NSActionUtil.setSessionAttribute(request,CollectionConst.STATIS_SAMPLING_TARGETID,targetID);
        return mapping.findForward("samplingEntry");
    }
}