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

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

public class VolumeExtendShowAction
    extends Action
    implements VolumeActionConst {
    public static final String cvsid =
        "@(#) $Id: VolumeExtendShowAction.java,v 1.14 2008/05/24 12:13:32 liuyq Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm dynaForm = (DynaValidatorForm) form;
        VolumeInfoBean volumeInfo = (VolumeInfoBean) dynaForm.get("volumeInfo");
        if (volumeInfo != null
            && volumeInfo.getVolumeName() != null
            && !volumeInfo.getVolumeName().equals("")) {

            volumeInfo.setStorage(
                NSActionUtil.reqStr2EncodeStr(
                    volumeInfo.getStorage(),
                    NSActionUtil.BROWSER_ENCODE));
            volumeInfo.setStorage4Extend(
                NSActionUtil.reqStr2EncodeStr(
                    volumeInfo.getStorage4Extend(),
                    NSActionUtil.BROWSER_ENCODE));
            NSActionUtil.setSessionAttribute(
                request,
                SESSION_VOLUME_INFO_OBJ,
                volumeInfo);
            NSActionUtil.setSessionAttribute(
                request,
                VOLUME_INFO_VOLUME_NAME,
                volumeInfo.getVolumeName());
        } else { // for lun init reload
            dynaForm.set(
                "volumeInfo",
                request.getSession().getAttribute(SESSION_VOLUME_INFO_OBJ));
        }
        
        // check whether the volume ahs been set as a pair, jiangfx,2008/04/13
        DdrHandler.isPaired(volumeInfo.getVolumeName());
        
        if (NSActionUtil.isNashead(request)) {
            request.setAttribute(
                "isGfsVolume",
                volumeInfo.getUseGfs());
            LicenseInfo license = LicenseInfo.getInstance();
            String hasGfsLicense =
                license.checkAvailable(
                    NSActionUtil.getCurrentNodeNo(request),
                    "gfs")
                    != 0
                    ? "true"
                    : "false";
            request.setAttribute("hasGfsLicense", hasGfsLicense);
            request.setAttribute("isNashead", "true");
        } else {
            volumeInfo.setPoolNameAndNo(
                VolumeDetailAction.compactAndSort(
                    volumeInfo.getPoolNameAndNo()));
            request.setAttribute("isNashead", "false");
        }
        
        VolumeAddShowAction.setLicenseChkSession(request);
        NSActionUtil.setSessionAttribute(request, VOLUME_FLAG_EXTEND, "extend");
        int nodeNo = NSActionUtil.getCurrentNodeNo(request); 
        String mountPoint = volumeInfo.getMountPoint();
        String hasSnapshot = VolumeHandler.hasSnapshotSet(mountPoint, nodeNo);
        String hasReplication = VolumeHandler.isSyncFS(mountPoint,nodeNo);
        request.setAttribute("hasSnapshot", hasSnapshot);
        request.setAttribute("hasReplication", hasReplication);
        if(hasReplication.equalsIgnoreCase("yes")){
            NSActionUtil.setSessionAttribute(request, VOLUME_FLAG_SHOWLUN4SYNCFS, "extend4syncfs");
        }

        return mapping.findForward("forwardToExtendShow");
    }
}
