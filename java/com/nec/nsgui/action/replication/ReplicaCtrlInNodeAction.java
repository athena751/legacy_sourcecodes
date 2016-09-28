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

public class ReplicaCtrlInNodeAction extends Action implements ReplicationActionConst {
    private static final String cvsid = "@(#) $Id: ReplicaCtrlInNodeAction.java,v 1.4 2008/06/17 10:40:23 jiangfx Exp $"; 
    
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        // get replica mount point and its original mount point
        ReplicaInfoBean replicaInfo = (ReplicaInfoBean)((DynaValidatorForm)form).get("replicaInfo");
        String replicaMP  = replicaInfo.getMountPoint();
        String originalMP = replicaInfo.getOriginalMP();
        NSActionUtil.setSessionAttribute(request, SESSION_MOUNT_POINT, replicaMP);
        
        // get operation of control in node
        String operation = (String)((DynaValidatorForm)form).get("operation");
        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        // check whether there is sync volume in the fileset, add by jiangfx, 2008.5.7
        ReplicaHandler.checkVolSyncInFileset(replicaInfo.getOriginalServer(),
        		                             replicaInfo.getFilesetName(),
        		                             "true",
        		                             nodeNo);        
        // replace or exchange according the operation
        ReplicaHandler.ctrlInNode(operation, replicaMP, originalMP, nodeNo);
        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("replicaList");
    }
} 