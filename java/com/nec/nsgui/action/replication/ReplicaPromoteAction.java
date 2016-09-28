/*
 *      Copyright (c) 2004-2008 NEC Corporation
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

public class ReplicaPromoteAction extends Action implements ReplicationActionConst {
    private static final String cvsid = "@(#) $Id: ReplicaPromoteAction.java,v 1.3 2008/06/04 04:56:25 liy Exp $"; 
    
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        ReplicaInfoBean replicaInfo = (ReplicaInfoBean)((DynaValidatorForm)form).get("replicaInfo");
        String mountPoint = replicaInfo.getMountPoint();
        NSActionUtil.setSessionAttribute(request, SESSION_MOUNT_POINT, mountPoint);
        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        // check whether there is sync volume in the fileset, add by jiangfx, 2008.5.7
        ReplicaHandler.checkVolSyncInFileset(replicaInfo.getOriginalServer(),
        		                             replicaInfo.getFilesetName(),
        		                             "false",
        		                             nodeNo);
        
        // promote replica volume as original volume
        String repliMethod = replicaInfo.getRepliMethod();
        String hour = (String)((DynaValidatorForm)form).get("hour");
        String minute = (String)((DynaValidatorForm)form).get("minute");
        ReplicaHandler.promoteReplica(mountPoint, repliMethod, hour, minute, nodeNo);
        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("replicaList");
    }
} 