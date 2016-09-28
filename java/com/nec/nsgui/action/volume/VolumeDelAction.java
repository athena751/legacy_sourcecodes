/*
 *      Copyright (c) 2004-2006 NEC Corporation
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

public class VolumeDelAction extends Action implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id: VolumeDelAction.java,v 1.5 2006/04/26 09:02:11 wangzf Exp $";

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
        
        VolumeHandler.delVolume(
            volumeInfo.getMountPoint(),
            NSActionUtil.getCurrentNodeNo(request));
        
        try{ //delete rrd file about statis base on [nsgui-necas-sv4:04165]
            String lvName = volumeInfo.getVolumeName();
            VolumeHandler.deleteRRDFile(lvName , VOLUME_NAS_LV_IO , NSActionUtil.getCurrentNodeNo(request));
            VolumeHandler.deleteRRDFile(lvName , VOLUME_FILE_SYSTEM , NSActionUtil.getCurrentNodeNo(request));
            VolumeHandler.deleteRRDFile(lvName , VOLUME_FILE_SYSTEM_QUANTITY , NSActionUtil.getCurrentNodeNo(request));
        } catch (Exception eee) {
        }
        
        request.getSession().setAttribute(
            NSActionConst.SESSION_SUCCESS_ALERT,
            "true");
        return mapping.findForward("delSuccess");
    }

}
