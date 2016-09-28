/*
 *      Copyright (c) 2004 NEC Corporation
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

public class VolumeMountAction extends Action implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id: VolumeMountAction.java,v 1.2 2005/06/13 01:54:19 liuyq Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        VolumeInfoBean volumeInfo =
            (VolumeInfoBean) ((DynaValidatorForm) form).get("volumeInfo");
        NSActionUtil.setSessionAttribute(request,
            VOLUME_INFO_VOLUME_NAME,
            volumeInfo.getVolumeName());
        VolumeHandler.mountVolume(
            volumeInfo.getMountPoint(),
            NSActionUtil.getCurrentNodeNo(request));
        request.getSession().setAttribute(
            NSActionConst.SESSION_SUCCESS_ALERT,
            "true");
        return mapping.findForward("mountSuccess");
    }

}
