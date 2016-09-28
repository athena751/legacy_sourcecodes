/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

import java.util.HashMap;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.*;
import com.nec.nsgui.model.biz.base.NSException;

public class SnmpAction extends DispatchAction implements SnmpActionConst {
    private static final String cvsid = "@(#) $Id: SnmpAction.java,v 1.3 2007/07/12 08:25:29 caows Exp $";
    
    protected void clearSession(HttpServletRequest request) {
        NSActionUtil.setSessionAttribute( request,SESSION_SNMP_COMMUNITYFORM,null);
        NSActionUtil.setSessionAttribute( request,SESSION_SNMP_USERFORM,null );
        NSActionUtil.setSessionAttribute( request,SESSION_SNMP_RECOVERYCONVERTFAILED,null );
    }
    
    protected void partnerFailedHandle(
            HttpServletRequest request,
            PartnerFailedProcessor processor)
            throws Exception {
    	request.getSession().setAttribute(
                NSActionConst.SESSION_NOFAILED_ALERT,
                "false");
        request.getSession().setAttribute(
                NSActionConst.SESSION_NOT_DISPLAY_DETAIL,
                "false");
        try {
            processor.process();
        } catch (NSException e) {
            if (e.getErrorCode().equals(ERRCODE_PARTNERFAILED)) {
                NSActionUtil.setSessionAttribute( request,SESSION_SNMP_PARTNERFAILED,"true");
            } else {
                NSActionUtil.setSessionAttribute( request,SESSION_SNMP_PARTNERFAILED,"false");
            }
            throw e;
        }
        NSActionUtil.setSessionAttribute( request, SESSION_SNMP_PARTNERFAILED, "false");
        NSActionUtil.setSuccess(request);
    }
    
    protected void exceptionHandler(
            HttpServletRequest request,
            HashMap infoHash,
            HashMap errorHash,
            NormalProcessor processor)
            throws Exception {
        Object info = infoHash.get("info");
        NSException nsep = (NSException) infoHash.get("exception");
        if (request.getSession().getAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE) == null && nsep != null) {
            Set keySet =  errorHash.keySet();
            String[] keyArray = (String[])keySet.toArray(new String[0]);
            for(int i = 0;i < keyArray.length; i++){
                if (nsep.getErrorCode().equals(keyArray[i])) {
                    ((ExceptionProcessor)errorHash.get(keyArray[i])).processExcep(info);
                }
            }
            throw nsep;
        }
        request.getSession().setAttribute(
                NSActionConst.SESSION_NOFAILED_ALERT,
                "false");
        request.getSession().setAttribute(
                NSActionConst.SESSION_NOT_DISPLAY_DETAIL,
                "false");
        processor.processNormal(info);
    }
}