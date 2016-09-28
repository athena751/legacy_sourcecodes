/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ndmpv4;



import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ndmpv4.NdmpHandler;

public class NdmpDeviceAction extends DispatchAction implements NdmpActionConst {
    private static final String cvsid = "@(#) $Id: NdmpDeviceAction.java,v 1.3 2006/12/26 03:01:16 wanghui Exp $";
    public ActionForward getDeviceInfo(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
            	        
        int groupNum = NSActionUtil.getCurrentNodeNo(request);   

        List deviceInfoList = NdmpHandler.getDeviceInfo(groupNum);       
       
        request.setAttribute("deviceInfoList", deviceInfoList);

        return mapping.findForward("deviceInfo");
    } 
    
    public ActionForward entryDeviceInfo(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int groupNum = NSActionUtil.getCurrentNodeNo(request);                
        String version = NdmpHandler.getRunningVersion(groupNum);
        if (version.equals("2")) {
            return (mapping.findForward("entryDeviceInfoV2"));
        } else {
            return (mapping.findForward("entryDeviceInfoV4"));
        }        
    } 
}