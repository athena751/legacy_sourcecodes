/*
 *      Copyright (c) 2008 NEC Corporation
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
import com.nec.nsgui.model.entity.replication.ReplicaInfoBean;

public class ReplicaVolumeSyncAction extends Action {
    private static final String cvsid = "@(#) $Id: ReplicaVolumeSyncAction.java,v 1.3 2008/05/28 02:11:07 lil Exp $"; 
    
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        // get replica mount point
        ReplicaInfoBean replicaInfo = (ReplicaInfoBean)((DynaValidatorForm)form).get("replicaInfo");
        String replicaMP  = replicaInfo.getMountPoint();
        
        // get the volume sync type
        String syncType = (String)((DynaValidatorForm)form).get("syncType");
        
        // sync the volume
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        ReplicaHandler.setVolumeSync(replicaMP, syncType, nodeNo);
        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("replicaList");
    }
}
