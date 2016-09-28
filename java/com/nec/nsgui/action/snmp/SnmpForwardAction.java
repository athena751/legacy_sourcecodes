/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.model.biz.base.CmdExecBase;

/**
 *For forward
 */
public class SnmpForwardAction extends Action{
    private static final String cvsid = "@(#) $Id: SnmpForwardAction.java,v 1.1 2005/08/22 06:06:50 zhangj Exp $";
    
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        CmdExecBase.checkClusterStatus();
        return mapping.findForward("snmpForward");
    }
}