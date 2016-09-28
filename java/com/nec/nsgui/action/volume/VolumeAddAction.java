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

public class VolumeAddAction extends Action implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id: VolumeAddAction.java,v 1.11 2007/09/07 08:38:37 liq Exp $";
    private static final String PREFIX_RAID6 = "6"; // when raid6, the value of volumeInfo.getRaidType() is "64" or "68"

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm inputForm = (DynaValidatorForm) form;
        VolumeInfoBean volumeInfo =
            (VolumeInfoBean) inputForm.get("volumeInfo");
        volumeInfo.setVolumeName("NV_LVM_" + volumeInfo.getVolumeName());
        boolean isSSeries = DiskCommon.isSSeries(request);
        VolumeHandler.addVolume(
            volumeInfo,
            NSActionUtil.getCurrentNodeNo(request),
            false,
            isSSeries);
        
        NSActionUtil.setSessionAttribute(request, 
                        VOLUME_INFO_VOLUME_NAME, 
                        volumeInfo.getVolumeName());
        
        if(DiskCommon.isCondorLiteSeries(request)|| NSActionUtil.isNashead(request)){
            if (volumeInfo.getReplication() != null
                && volumeInfo.getReplication().booleanValue()) {
                request.setAttribute("from" , "volume");
                request.setAttribute("module" , 
                    volumeInfo.getReplicType().equals("replic") ? "replica" : "original");
                return mapping.findForward("forwardReplication");
            }
        }     
        request.getSession().setAttribute(
            NSActionConst.SESSION_SUCCESS_ALERT,
            "true");
        return mapping.findForward("addSuccess");
    }
}
