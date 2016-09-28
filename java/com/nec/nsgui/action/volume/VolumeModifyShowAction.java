/*
 *      Copyright (c) 2004-2009 NEC Corporation
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
import java.util.List;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.biz.snapshot.ReplicaSnapshotHandler;
import com.nec.nsgui.model.entity.snapshot.SnapshotAreaBean;

public class VolumeModifyShowAction extends Action implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id: VolumeModifyShowAction.java,v 1.7 2009/01/13 11:26:05 xingyh Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        VolumeInfoBean volumeInfo = (VolumeInfoBean)((DynaValidatorForm) form).get("volumeInfo");
        
        NSActionUtil.setSessionAttribute(request,
                VOLUME_INFO_VOLUME_NAME,
                volumeInfo.getVolumeName());
        
        String mp = volumeInfo.getMountPoint();
        String canSetDmapi = VolumeHandler.canSetDmapi(mp , NSActionUtil.getCurrentNodeNo(request));
        ((DynaValidatorForm) form).set("canSetDmapi" , canSetDmapi);

        if (NSActionUtil.isNashead(request)) {
            LicenseInfo license = LicenseInfo.getInstance();
            String hasGfsLicense =
                license.checkAvailable(NSActionUtil.getCurrentNodeNo(request), "gfs")
                    != 0  ? "true" : "false";
            request.setAttribute("hasGfsLicense", hasGfsLicense);
            request.setAttribute("isNashead", "true");
        }else{
            request.setAttribute("isNashead", "false");
        }
        
        //check the specified volume is paired or not when volume is RV
        String volName = volumeInfo.getVolumeName();
        if (!volName.startsWith("NV_LVM")) {
        	DdrHandler.isPaired(volName);
        }
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        List <SnapshotAreaBean> snapshotAreaInfo = ReplicaSnapshotHandler.getSnapshotArea(mp, nodeNo);
        SnapshotAreaBean snapshotInfo = snapshotAreaInfo.get(0);
        request.setAttribute("usedSnapshotArea", snapshotInfo.getUsedArea());
        
        return mapping.findForward("forwardToModifyShow");
    }

}
