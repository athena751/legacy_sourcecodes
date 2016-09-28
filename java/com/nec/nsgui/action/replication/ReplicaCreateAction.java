/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.replication.ReplicaHandler;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.replication.ReplicaInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.action.disk.DiskCommon;

/**
 *
 */
public class ReplicaCreateAction
    extends Action
    implements ReplicationActionConst {
    public static final String cvsid =
        "@(#) $Id: ReplicaCreateAction.java,v 1.8 2007/09/07 08:34:41 liq Exp $";

    /* (non-Javadoc)
     * @see org.apache.struts.action.Action#execute(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        ReplicaHandler repliHandler = ReplicaHandler.getInstance();
        DynaValidatorForm inputForm = (DynaValidatorForm) form;
        boolean format = ((Boolean) inputForm.get("format")).booleanValue();
        boolean newVolume =
            ((String) inputForm.get("newVolume")).equals("newVolume");
        ReplicaInfoBean replicaInfo =
            (ReplicaInfoBean) inputForm.get("replicaInfo");
        
        if (newVolume) {
            VolumeInfoBean volumeInfo =
                (VolumeInfoBean) inputForm.get("volumeInfo");
            volumeInfo.setVolumeName("NV_LVM_" + volumeInfo.getVolumeName());
            replicaInfo.setMountPoint(volumeInfo.getMountPoint());
            boolean isSSeries = DiskCommon.isSSeries(request);
            // when isSSeries is true ,is not a Nashead mechine xingyh
            if (isSSeries) {
            	int nodeNo = NSActionUtil.getCurrentNodeNo(request);
                repliHandler.createVolAndReplica(volumeInfo, replicaInfo, nodeNo);        
            } else {
                VolumeHandler.addVolume(
                    volumeInfo,
                    NSActionUtil.getCurrentNodeNo(request),
                    false,isSSeries);
                repliHandler.createReplic(
                    replicaInfo,
                    NSActionUtil.getCurrentNodeNo(request));
            }
        } else {
            repliHandler.useExsitVolume4Replica(
                replicaInfo.getMountPoint(),
                format,
                NSActionUtil.getCurrentNodeNo(request));
            repliHandler.createReplic(
                replicaInfo,
                NSActionUtil.getCurrentNodeNo(request));                
        }

        NSActionUtil.setSessionAttribute(
            request,
            SESSION_MOUNT_POINT,
            replicaInfo.getMountPoint());
        NSActionUtil.setSuccess(request);
        return mapping.findForward("replicaList");
    }

}
