/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.rdr_dr;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.rdr_dr.Rdr_drHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;

public class Rdr_drChangeModeAction extends DispatchAction implements Rdr_drActionConst {
    private static final String cvsid = "@(#) $Id: Rdr_drChangeModeAction.java,v 1.4 2005/10/24 01:45:03 jiangfx Exp $";
   
    public ActionForward display(ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {
        
        // get current nodeNo
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
      
        LicenseInfo license = LicenseInfo.getInstance();
        if ((license.checkAvailable(nodeNo, "rdrdr")) == 0){
            request.setAttribute("licenseKey", "rdrdr");
            return mapping.findForward("noLicense");
        }
        
        Rdr_drHandler rdr_drHandler = new Rdr_drHandler(); // declare an instance of Rdr_drHandler
            
        // get current mode
        String currentMode = rdr_drHandler.getCurrentMode(nodeNo); 
        request.setAttribute("currentMode", currentMode);
        
        if (NSActionUtil.isNsview(request)) {
            return mapping.findForward("displayPage4Nsview");
        } else {
            return mapping.findForward("displayPage4Nsadmin");     
        }                                          
    }
    
    public ActionForward changeMode(ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {
        
        // get nextMode from request
        String nextMode = request.getParameter("nextMode");
        
        // get current nodeNo
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        
        // change mode       
        Rdr_drHandler rdr_drHandler = new Rdr_drHandler(); // declare an instance of Rdr_drHandler
        rdr_drHandler.changMode(nextMode, nodeNo);
        
        return mapping.findForward("reloadPage");                                           
    }   
 
}