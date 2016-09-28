/*
 *      Copyright (c) 2004-2007 NEC Corporation
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
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.action.disk.DiskCommon;

public class VolumeExtendAction extends Action {
    public static final String cvsid =
        "@(#) $Id: VolumeExtendAction.java,v 1.6 2007/09/07 08:40:30 liq Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        boolean isNashead = NSActionUtil.isNashead(request);
        VolumeInfoBean volumeInfo = (VolumeInfoBean) ((DynaValidatorForm) form).get("volumeInfo");
        boolean isSSeries = DiskCommon.isSSeries(request);
        VolumeHandler.extendVolume(volumeInfo, isNashead, nodeNo,isSSeries);
        
        request.getSession().setAttribute(
            NSActionConst.SESSION_SUCCESS_ALERT,
            "true");
        return mapping.findForward("extendSuccess");
    }

}