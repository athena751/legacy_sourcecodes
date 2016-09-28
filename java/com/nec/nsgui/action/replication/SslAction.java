/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.replication.ReplicaHandler;

/**
 * 
 *
 */
public class SslAction extends DispatchAction implements ReplicationActionConst {
    private static final String cvsid = "@(#) $Id: SslAction.java,v 1.1 2005/09/15 05:52:57 liyb Exp $";
        
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        // get SSL status
        ReplicaHandler replicaHandler = new ReplicaHandler();
        String sslStatus = replicaHandler.getSslStatus(NSActionUtil.getCurrentNodeNo(request));
        
        // set SSL status to form
        ((DynaValidatorForm)form).set("sslStatus", sslStatus);

        if (NSActionUtil.isNsview(request)) {
            return mapping.findForward("ssl4Nsview");
        } else {
            return mapping.findForward("ssl4Nsadmin");       
        }
    }
    
    public ActionForward set(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        String sslStatus = (String)((DynaValidatorForm)form).get("sslStatus");
        sslStatus = ((sslStatus != null) && sslStatus.equals("on")) ? sslStatus : "off";
        
        // set SSL status
        ReplicaHandler.setSslStatus(sslStatus, NSActionUtil.getCurrentNodeNo(request));
        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("sslShow");       

    }

}
