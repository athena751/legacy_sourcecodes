/*
 *      Copyright (c) 2004-2008 NEC Corporation
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

public class VolumeModifyAction extends Action implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id: VolumeModifyAction.java,v 1.4 2008/02/29 11:34:50 wanghb Exp $";

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
            
        String access = (String)request.getParameter("oldAccess");
        String replication = (String)request.getParameter("oldRepli");
        String repliType = (String)request.getParameter("repli_type");
        if(replication.equals("false")){
            volumeInfo.setReplication(new Boolean(false));//Can not get variable replication  from request when it is disabled.
        }else{
            if(!repliType.equals("")){//Can not get variable replication from request when it is disabled.
                volumeInfo.setAccessMode(access);
                volumeInfo.setReplication(new Boolean(true));
            }
        }
      
        VolumeHandler.modifyVolume(
            volumeInfo,
            NSActionUtil.getCurrentNodeNo(request));
        request.getSession().setAttribute(
            NSActionConst.SESSION_SUCCESS_ALERT,
            "true");
        return mapping.findForward("modifySuccess");
    }

}
