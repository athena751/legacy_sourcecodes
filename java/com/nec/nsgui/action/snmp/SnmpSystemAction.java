/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.snmp.SnmpCmdHandler;
import com.nec.nsgui.model.entity.snmp.SystemInfoBean;

/**
 *For System
 */
public class SnmpSystemAction extends SnmpAction{
    private static final String cvsid = "@(#) $Id: SnmpSystemAction.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";

    public ActionForward display(
            ActionMapping mapping,
            final ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        clearSession(request);
        HashMap infoHash = SnmpCmdHandler.getSystemInfo(false);
        HashMap errorHash = new HashMap();
        
        errorHash.put(ERRCODE_RECOVERY, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                ((DynaActionForm) form).set("systemInfo",info);
				request.setAttribute("recoveryFlag", "true");
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        exceptionHandler(request,infoHash,errorHash,new NormalProcessor(){
            public void processNormal(Object info)throws Exception{
                ((DynaActionForm) form).set("systemInfo",info);
            }
        });
        
        return mapping.findForward("displaySetTop");
    }
    
    public ActionForward modify(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        final SystemInfoBean systemInfo = (SystemInfoBean)((DynaActionForm)form).get("systemInfo");
        partnerFailedHandle(request,new PartnerFailedProcessor(){
            public void process()throws Exception{
                SnmpCmdHandler.modifySysInfo(systemInfo);
            }
        });
        
        return mapping.findForward("displaySetFrame");
    }
}