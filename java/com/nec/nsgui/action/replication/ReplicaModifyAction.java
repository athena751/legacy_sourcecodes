/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.replication.ReplicaHandler;
import com.nec.nsgui.model.entity.replication.ReplicaInfoBean;

/**
 *
 */
public class ReplicaModifyAction
    extends DispatchAction
    implements ReplicationActionConst {
    public static final String cvsid =
         "@(#) $Id: ReplicaModifyAction.java,v 1.3 2008/06/04 04:55:39 liy Exp $";

    /* (non-Javadoc)
     * @see org.apache.struts.action.Action#execute(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm inputForm = (DynaValidatorForm) form;
        ReplicaInfoBean replicaInfo =
                        (ReplicaInfoBean) (inputForm.get("replicaInfo"));
        String ipValue = replicaInfo.getTransInterface();
        ipValue = ipValue.replaceAll("NoBindings", "");
        if(ipValue.indexOf("(") != -1){
            ipValue = ipValue.substring(0, ipValue.indexOf("("));
        }
        replicaInfo.setTransInterface(ipValue);
        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        request.setAttribute(
            "interfaceVec",
            ReplicaCreateShowAction.getInterfaceVec(nodeNo));
       
        // set snap-keep option
        String snapkeepLimit = replicaInfo.getSnapKeepLimit();
        if (snapkeepLimit.equals("--")) {
        	replicaInfo.setSnapKeepLimit("");
        	replicaInfo.setUseSnapKeep("off");
        } else {
        	replicaInfo.setUseSnapKeep("on");
        }
        inputForm.set("replicaInfo", replicaInfo);
        
        NSActionUtil.setSessionAttribute(
            request,
            SESSION_MOUNT_POINT,
            replicaInfo.getMountPoint());
        return mapping.findForward("replicaModifyShow");
    }

    /* (non-Javadoc)
     * @see org.apache.struts.action.Action#execute(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    public ActionForward modify(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm inputForm = (DynaValidatorForm) form;
        ReplicaHandler repliHandler = ReplicaHandler.getInstance();

        ReplicaInfoBean replicaInfo =
            (ReplicaInfoBean) (inputForm.get("replicaInfo"));

        // set the status of snap-keep's checkbox
        String useSnapkeep = replicaInfo.getUseSnapKeep();
        if ((useSnapkeep == null) || !useSnapkeep.equals("on")) {
        	replicaInfo.setSnapKeepLimit("--");
        	replicaInfo.setUseSnapKeep("off");
        }
        inputForm.set("replicaInfo", replicaInfo);
        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        // check whether there is sync volume in the fileset, add by jiangfx, 2008.5.7
        ReplicaHandler.checkVolSyncInFileset(replicaInfo.getOriginalServer(),
        		                             replicaInfo.getFilesetName(),
        		                             "false",
        		                             nodeNo);        
        repliHandler.modifyReplic(replicaInfo, nodeNo);
        NSActionUtil.setSessionAttribute(
            request,
            SESSION_MOUNT_POINT,
            replicaInfo.getMountPoint());
        NSActionUtil.setSuccess(request);
        return mapping.findForward("replicaList");
    }

}
